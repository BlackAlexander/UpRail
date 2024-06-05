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

documents_path = os.path.join(os.path.expanduser('~'), 'Documents')
env_path = os.path.join(documents_path, 'upRail', 'Environment.uprail')


def check_env():
    env_content = "mock_sim_slope_diffusion: 0.3\ngravity_acceleration: 9.8\nlow_efficiency_obstruction: 1\n" \
                  "low_efficiency_timer: 1000"
    if not os.path.exists(env_path):
        with open(env_path, 'w') as file:
            file.write(env_content)


def main():
    print("Server running...")
    check_env()
    time.sleep(3600)
    restore_test_comm()


if __name__ == "__main__":
    # os.startfile("C:\\Users\\flanco\\Desktop\\upRail\\upRail.exe")
    main()
