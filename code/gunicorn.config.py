from resources.tokens import delete_stale_worker

bind = '127.0.0.1:5000'
workers = 4
# daemon = True
umask = 0o22


def on_starting(server):
  delete_stale_worker.start()


def on_exit(server):
  delete_stale_worker.stop()
