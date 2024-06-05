import time
import threading
import os

from pingRespond import monitor_ping
from commRespond import monitor_comm, restore_test_comm

ping_thread = threading.Thread(target=monitor_ping)
ping_thread.daemon = True
ping_thread.start()

comm_thread = threading.Thread(target=monitor_comm)
comm_thread.daemon = True
comm_thread.start()


def main():
    print("Server running...")
    time.sleep(2000)
    restore_test_comm()


if __name__ == "__main__":
    # os.startfile("C:\\Users\\flanco\\Desktop\\upRail\\upRail.exe")
    main()
