import http.server
import json
from pathlib import Path

ROOT = Path(__file__).parent
CHOICES = ROOT / "choices.json"
PORT = 8765


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)

    def do_POST(self):
        if self.path != "/choices":
            self.send_error(404)
            return
        body = self.rfile.read(int(self.headers["Content-Length"]))
        CHOICES.write_text(json.dumps(json.loads(body), ensure_ascii=False, indent=1))
        self.send_response(204)
        self.end_headers()


if __name__ == "__main__":
    http.server.ThreadingHTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
