import time
import threading

from pingRespond import monitor_ping
from commRespond import monitor_comm

ping_thread = threading.Thread(target=monitor_ping)
ping_thread.daemon = True
ping_thread.start()

comm_thread = threading.Thread(target=monitor_comm)
comm_thread.daemon = True
comm_thread.start()


def main():
    print("Server running...")
    time.sleep(50)


if __name__ == "__main__":
    main()
