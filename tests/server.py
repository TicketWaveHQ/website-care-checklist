#!/usr/bin/env python3
"""Local fixture server for tests/smoke.sh. Standard library only.

  /          200, all six security headers, body contains "Fresh bread daily"
  /bare      200, no security headers
  /redirect  301 to /bare, carrying the security headers on the redirect only
  anything else  404

Usage: python3 tests/server.py <port>
"""
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer

SECURITY_HEADERS = {
    "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
    "Content-Security-Policy": "default-src 'self'",
    "X-Content-Type-Options": "nosniff",
    "Referrer-Policy": "strict-origin-when-cross-origin",
    "Permissions-Policy": "camera=(), microphone=(), geolocation=()",
    "X-Frame-Options": "DENY",
}


class Handler(BaseHTTPRequestHandler):
    def _send(self, status, body=b"", headers=None):
        self.send_response(status)
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        if self.command != "HEAD":
            self.wfile.write(body)

    def do_GET(self):
        if self.path == "/":
            self._send(200, b"<!doctype html><title>Bakery</title><p>Fresh bread daily</p>", SECURITY_HEADERS)
        elif self.path == "/bare":
            self._send(200, b"<!doctype html><title>Bare</title><p>No headers here</p>")
        elif self.path == "/redirect":
            self._send(301, b"", {**SECURITY_HEADERS, "Location": "/bare"})
        else:
            self._send(404, b"not found")

    do_HEAD = do_GET

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    HTTPServer(("127.0.0.1", int(sys.argv[1])), Handler).serve_forever()
