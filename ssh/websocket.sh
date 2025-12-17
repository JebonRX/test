#!/bin/bash
# =========================================
# Addons SSH Websocket
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================

clear
echo Installing Websocket-SSH Python
sleep 1
echo Wait a bit...
sleep 1
cd

# ================================
# SYSTEMD WEBSOCKET HTTPS (443)
# ================================
cat <<EOF> /etc/systemd/system/ws-https.service
[Unit]
Description=Python Proxy
Documentation=https://github.com/NevermoreSSH/
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Restart=on-failure
ExecStart=/usr/bin/python3 -O /usr/local/bin/ws-https

[Install]
WantedBy=multi-user.target
EOF

# ================================
# SYSTEMD WEBSOCKET HTTP (80)
# ================================
cat <<EOF> /etc/systemd/system/ws-http.service
[Unit]
Description=Python Proxy
Documentation=https://github.com/NevermoreSSH/
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Restart=on-failure
ExecStart=/usr/bin/python3 -O /usr/local/bin/ws-http

[Install]
WantedBy=multi-user.target
EOF

# ================================
# DOWNLOAD PYTHON FILES
# ================================
cat <<EOF> /usr/local/bin/ws-https
#!/usr/bin/python3
# -*- coding: utf-8 -*-
import socket, threading, select, sys, time, getopt

# Listen
LISTENING_ADDR = '127.0.0.1'
LISTENING_PORT = 2091
PASS = ''

# CONST
BUFLEN = 4096 * 4
TIMEOUT = 60
DEFAULT_HOST = '127.0.0.1:777'
RESPONSE = ("""HTTP/1.1 101 <b><u><font color="green"> HTTPS 443 Connection Successful – Script By NevermoreSSH </font></b>



Content-Length: 104857600000

""").encode("utf-8")
class Server(threading.Thread):
    def __init__(self, host, port):
        super().__init__()
        self.running = False
        self.host = host
        self.port = int(port)
        self.threads = []
        self.threadsLock = threading.Lock()
        self.logLock = threading.Lock()

    def run(self):
        self.soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.settimeout(2)
        self.soc.bind((self.host, self.port))
        self.soc.listen(15)
        self.running = True

        try:
            while self.running:
                try:
                    c, addr = self.soc.accept()
                    c.setblocking(1)
                except socket.timeout:
                    continue
                conn = ConnectionHandler(c, self, addr)
                conn.start()
                self.addConn(conn)
        finally:
            self.running = False
            self.soc.close()

    def printLog(self, log):
        with self.logLock:
            print(log)

    def addConn(self, conn):
        with self.threadsLock:
            if self.running:
                self.threads.append(conn)

    def removeConn(self, conn):
        with self.threadsLock:
            if conn in self.threads:
                self.threads.remove(conn)

    def close(self):
        self.running = False
        with self.threadsLock:
            threads = list(self.threads)
            for c in threads:
                c.close()

class ConnectionHandler(threading.Thread):
    def __init__(self, socClient, server, addr):
        super().__init__()
        self.clientClosed = False
        self.targetClosed = True
        self.client = socClient
        self.client_buffer = b''
        self.server = server
        self.log = f'Connection: {addr}'

    def close(self):
        try:
            if not self.clientClosed:
                self.client.shutdown(socket.SHUT_RDWR)
                self.client.close()
        except Exception:
            pass
        self.clientClosed = True

        try:
            if hasattr(self, "target") and not self.targetClosed:
                self.target.shutdown(socket.SHUT_RDWR)
                self.target.close()
        except Exception:
            pass
        self.targetClosed = True

    def run(self):
        try:
            self.client_buffer = self.client.recv(BUFLEN)
            buf_str = self.client_buffer.decode(errors='ignore')
            hostPort = self.findHeader(buf_str, 'X-Real-Host') or DEFAULT_HOST
            split = self.findHeader(buf_str, 'X-Split')
            if split:
                self.client.recv(BUFLEN)
            if hostPort:
                passwd = self.findHeader(buf_str, 'X-Pass')
                if PASS and passwd == PASS:
                    self.method_CONNECT(hostPort)
                elif PASS and passwd != PASS:
                    self.client.send(b'HTTP/1.1 400 WrongPass!\r\n\r\n')
                elif hostPort.startswith('127.0.0.1') or hostPort.startswith('localhost'):
                    self.method_CONNECT(hostPort)
                else:
                    self.client.send(b'HTTP/1.1 403 Forbidden!\r\n\r\n')
            else:
                self.server.printLog('- No X-Real-Host!')
                self.client.send(b'HTTP/1.1 400 NoXRealHost!\r\n\r\n')
        except Exception as e:
            self.log += f' - error: {str(e)}'
            self.server.printLog(self.log)
        finally:
            self.close()
            self.server.removeConn(self)

    def findHeader(self, head, header):
        idx = head.find(header + ': ')
        if idx == -1:
            return ''
        start = head.find(':', idx) + 2
        end = head.find('\r\n', start)
        if end == -1:
            return ''
        return head[start:end]

    def connect_target(self, host):
        i = host.find(':')
        if i != -1:
            port = int(host[i+1:])
            host = host[:i]
        else:
            port = 443
        infos = socket.getaddrinfo(host, port, socket.AF_INET, socket.SOCK_STREAM)
        family, socktype, proto, _, address = infos[0]
        self.target = socket.socket(family, socktype, proto)
        self.targetClosed = False
        self.target.connect(address)

    def method_CONNECT(self, path):
        self.log += ' - CONNECT ' + path
        self.connect_target(path)
        self.client.sendall(RESPONSE)
        self.client_buffer = b''
        self.server.printLog(self.log)
        self.doCONNECT()

    def doCONNECT(self):
        socs = [self.client, self.target]
        count = 0
        error = False
        while True:
            count += 1
            recv, _, err = select.select(socs, [], socs, 3)
            if err:
                error = True
            if recv:
                for in_ in recv:
                    try:
                        data = in_.recv(BUFLEN)
                        if data:
                            if in_ is self.target:
                                self.client.send(data)
                            else:
                                while data:
                                    sent = self.target.send(data)
                                    data = data[sent:]
                            count = 0
                        else:
                            break
                    except Exception:
                        error = True
                        break
            if count == TIMEOUT or error:
                break

def print_usage():
    print('Usage: proxy.py -p <port>')
    print('       proxy.py -b <bindAddr> -p <port>')
    print('       proxy.py -b 0.0.0.0 -p 80')

def parse_args(argv):
    global LISTENING_ADDR
    global LISTENING_PORT
    try:
        opts, args = getopt.getopt(argv,"hb:p:",["bind=","port="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_usage()
            sys.exit()
        elif opt in ("-b", "--bind"):
            LISTENING_ADDR = arg
        elif opt in ("-p", "--port"):
            LISTENING_PORT = int(arg)

def main():
    parse_args(sys.argv[1:])
    print("\n:-------PythonProxy-------:\n")
    print(f"Listening addr: {LISTENING_ADDR}")
    print(f"Listening port: {LISTENING_PORT}\n")
    print(":-------------------------:\n")
    server = Server(LISTENING_ADDR, LISTENING_PORT)
    server.start()
    try:
        while True:
            time.sleep(2)
    except KeyboardInterrupt:
        print('Stopping...')
        server.close()

if __name__ == '__main__':
    main()

EOF

#wget -q -O /usr/local/bin/ws-https https://raw.githubusercontent.com/NevermoreSSH/SkyNode/main/ssh/ws-https
chmod +x /usr/local/bin/ws-https

cat <<EOF> /usr/local/bin/ws-http
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import socket
import threading
import select
import signal
import sys
import time
import getopt

# Listen defaults
LISTENING_ADDR = '127.0.0.1'
LISTENING_PORT = 2092

# Optional password check (empty = disabled)
PASS = ''

# CONST
BUFLEN = 4096 * 4
TIMEOUT = 60
DEFAULT_HOST = '127.0.0.1:109'
# A simple 101 response (as bytes). Adjust if you need the original custom text.
RESPONSE = (
    "HTTP/1.1 101 <b><u><font color=\"green\"> HTTP 80 Connection Successful – Script by NevermoreSSH </font></u></b>\r\n\r\n\r\n\r\n"
    "Content-Length: 104857600000\r\n\r\n"
).encode()



class Server(threading.Thread):
    def __init__(self, host, port):
        super().__init__(daemon=True)
        self.running = False
        self.host = host
        self.port = int(port)
        self.threads = []
        self.threadsLock = threading.Lock()
        self.logLock = threading.Lock()
        self.soc = None

    def run(self):
        self.soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.settimeout(2)
        self.soc.bind((self.host, self.port))
        # backlog larger than 0
        self.soc.listen(50)
        self.running = True
        try:
            while self.running:
                try:
                    c, addr = self.soc.accept()
                    c.setblocking(1)
                except socket.timeout:
                    continue
                conn = ConnectionHandler(c, self, addr)
                conn.start()
                self.addConn(conn)
        finally:
            self.running = False
            try:
                if self.soc:
                    self.soc.close()
            except Exception:
                pass

    def printLog(self, log):
        with self.logLock:
            print(log, flush=True)

    def addConn(self, conn):
        with self.threadsLock:
            if self.running:
                self.threads.append(conn)

    def removeConn(self, conn):
        with self.threadsLock:
            try:
                self.threads.remove(conn)
            except ValueError:
                pass

    def close(self):
        self.running = False
        with self.threadsLock:
            threads = list(self.threads)
        for c in threads:
            try:
                c.close()
            except Exception:
                pass
        try:
            if self.soc:
                self.soc.close()
        except Exception:
            pass


class ConnectionHandler(threading.Thread):
    def __init__(self, socClient, server, addr):
        super().__init__(daemon=True)
        self.clientClosed = False
        self.targetClosed = True
        self.client = socClient
        self.client_buffer = b''
        self.server = server
        self.log = 'Connection: ' + str(addr)
        self.target = None
        self.method = None

    def close(self):
        try:
            if not self.clientClosed:
                self.client.shutdown(socket.SHUT_RDWR)
                self.client.close()
        except Exception:
            pass
        finally:
            self.clientClosed = True

        try:
            if not self.targetClosed and self.target:
                self.target.shutdown(socket.SHUT_RDWR)
                self.target.close()
        except Exception:
            pass
        finally:
            self.targetClosed = True

    def run(self):
        try:
            # read initial buffer (may be HTTP headers with X-Real-Host etc)
            self.client_buffer = self.client.recv(BUFLEN)
            headers = self.parse_headers(self.client_buffer)

            hostPort = headers.get('x-real-host', '') or DEFAULT_HOST
            split = headers.get('x-split', '')
            if split:
                # consume extra buffer if requested
                try:
                    _ = self.client.recv(BUFLEN)
                except Exception:
                    pass

            if hostPort:
                passwd = headers.get('x-pass', '')
                if PASS and passwd == PASS:
                    self.method_CONNECT(hostPort)
                elif PASS and passwd != PASS:
                    self.client.sendall(b'HTTP/1.1 400 WrongPass!\r\n\r\n')
                elif hostPort.startswith('127.0.0.1') or hostPort.startswith('localhost'):
                    self.method_CONNECT(hostPort)
                else:
                    self.client.sendall(b'HTTP/1.1 403 Forbidden!\r\n\r\n')
            else:
                self.server.printLog('- No X-Real-Host!')
                self.client.sendall(b'HTTP/1.1 400 NoXRealHost!\r\n\r\n')

        except Exception as e:
            self.log += ' - error: ' + str(e)
            self.server.printLog(self.log)
        finally:
            self.close()
            self.server.removeConn(self)

    def parse_headers(self, data_bytes):
        """
        Parse the initial request buffer for headers.
        Returns a dict of lower-case header -> value (strings).
        """
        headers = {}
        if not data_bytes:
            return headers
        try:
            text = data_bytes.decode('iso-8859-1', errors='ignore')
        except Exception:
            text = str(data_bytes)
        # split on CRLF
        lines = text.split('\r\n')
        for line in lines[1:]:
            if not line:
                break
            parts = line.split(':', 1)
            if len(parts) == 2:
                headers[parts[0].strip().lower()] = parts[1].strip()
        return headers

    def connect_target(self, host):
        """
        host may be "hostname:port" or hostname
        """
        # parse host and port
        i = host.rfind(':')
        if i != -1 and host[i+1:].isdigit():
            port = int(host[i+1:])
            hostname = host[:i]
        else:
            # default to 443 for CONNECT; otherwise default port 80
            if self.method == 'CONNECT':
                port = 443
            else:
                port = 80
            hostname = host

        try:
            # use getaddrinfo to support IPv6
            infos = socket.getaddrinfo(hostname, port, 0, socket.SOCK_STREAM)
            if not infos:
                raise OSError("getaddrinfo returned no address for %s:%s" % (hostname, port))
            soc_family, soc_type, proto, _, address = infos[0]
            self.target = socket.socket(soc_family, soc_type, proto)
            self.target.settimeout(6)
            self.targetClosed = False
            self.target.connect(address)
            # set blocking after connect
            self.target.setblocking(1)
        except Exception as e:
            raise

    def method_CONNECT(self, path):
        self.method = 'CONNECT'
        self.log += ' - CONNECT ' + str(path)
        try:
            self.connect_target(path)
        except Exception as e:
            self.server.printLog(self.log + ' - connect failed: ' + str(e))
            try:
                self.client.sendall(b'HTTP/1.1 502 Bad Gateway\r\n\r\n')
            except Exception:
                pass
            return

        try:
            self.client.sendall(RESPONSE)
        except Exception:
            pass

        # clear buffer
        self.client_buffer = b''
        self.server.printLog(self.log)
        self.doCONNECT()

    def doCONNECT(self):
        socs = [self.client, self.target]
        count = 0
        error = False
        while True:
            count += 1
            try:
                recv, _, err = select.select(socs, [], socs, 3)
            except Exception:
                error = True
                break

            if err:
                error = True

            if recv:
                for in_ in recv:
                    try:
                        data = in_.recv(BUFLEN)
                        if not data:
                            # remote closed
                            error = True
                            break
                        if in_ is self.target:
                            # data from target -> send to client
                            try:
                                self.client.sendall(data)
                            except Exception:
                                error = True
                                break
                        else:
                            # data from client -> forward to target
                            try:
                                self.target.sendall(data)
                            except Exception:
                                error = True
                                break
                        count = 0
                    except Exception:
                        error = True
                        break
            if count >= TIMEOUT:
                error = True
            if error:
                break


def print_usage():
    print('Usage: proxy.py -p <port>')
    print('       proxy.py -b <bindAddr> -p <port>')
    print('       proxy.py -b 0.0.0.0 -p 80')


def parse_args(argv):
    global LISTENING_ADDR, LISTENING_PORT
    try:
        opts, args = getopt.getopt(argv, "hb:p:", ["bind=", "port="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_usage()
            sys.exit()
        elif opt in ("-b", "--bind"):
            LISTENING_ADDR = arg
        elif opt in ("-p", "--port"):
            LISTENING_PORT = int(arg)


def main(host=LISTENING_ADDR, port=LISTENING_PORT):
    print("\n:-------PythonProxy-------:\n")
    print("Listening addr: " + str(host))
    print("Listening port: " + str(port) + "\n")
    print(":-------------------------:\n")

    server = Server(host, port)

    # handle Ctrl+C to shut down cleanly
    def sigint_handler(signum, frame):
        print("Stopping...", flush=True)
        server.close()
        sys.exit(0)

    signal.signal(signal.SIGINT, sigint_handler)

    server.start()
    try:
        while True:
            time.sleep(2)
    except KeyboardInterrupt:
        print('Stopping...')
        server.close()


if __name__ == '__main__':
    parse_args(sys.argv[1:])
    main(LISTENING_ADDR, LISTENING_PORT)

EOF

#wget -q -O /usr/local/bin/ws-http https://raw.githubusercontent.com/NevermoreSSH/SkyNode/main/ssh/ws-http
chmod +x /usr/local/bin/ws-http

# ================================
# ENABLE & RESTART SERVICES
# ================================
systemctl daemon-reload
systemctl enable ws-https
systemctl restart ws-https
systemctl enable ws-http
systemctl restart ws-http

# delete any setup
rm -r websocket.sh
echo "✅ SSH Websocket installed and running!"
sleep 1
