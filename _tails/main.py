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
uprail_path = os.path.join(documents_path, "upRail")


def check_env():
    if not os.path.exists(uprail_path):
        os.makedirs(uprail_path)
        print("Created 'upRail' directory")

    text_files = ["COMM.uprail", "MAP.uprail", "PING.uprail", "SIM.uprail"]

    env_content = "mock_sim_slope_diffusion: 0.3\ngravity_acceleration: 9.8\nlow_efficiency_obstruction: 1\n" \
                  "low_efficiency_timer: 1000"
    if not os.path.exists(env_path):
        with open(env_path, 'w') as file:
            file.write(env_content)

    for file_name in text_files:
        file_path = os.path.join(uprail_path, file_name)
        if not os.path.exists(file_path):
            with open(file_path, 'w') as f:
                f.write("")
            print(f"Created '{file_name}' file")


def main():
    print("Server running...")
    check_env()
    time.sleep(3600)
    # restore_test_comm()


if __name__ == "__main__":
    # os.startfile("C:\\Users\\flanco\\Desktop\\upRail\\upRail.exe")
    main()
