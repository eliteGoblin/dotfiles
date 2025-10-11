import random
import time
import pyautogui
import argparse
from pynput.keyboard import Controller

# Create an instance of the keyboard controller
keyboard = Controller()

# Define the Base64 character set: letters, digits, + and /
base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

# Function to type a random Base64 character
def type_random_base64_char():
    random_char = random.choice(base64_chars)
    keyboard.type(random_char)
    print(f"Typed: {random_char}")

# Function to move the cursor randomly around the current position
def move_cursor_randomly():
    current_x, current_y = pyautogui.position()
    move_x = random.randint(-50, 50)
    move_y = random.randint(-50, 50)
    pyautogui.moveTo(current_x + move_x, current_y + move_y, duration=0.2)
    print(f"Moved cursor by: ({move_x}, {move_y})")

# Function to handle typing or moving for a specified duration
def type_or_move_for_duration(duration_in_minutes):
    duration_in_seconds = duration_in_minutes * 60
    start_time = time.time()
    while time.time() - start_time < duration_in_seconds:
        if random.choice([True, False]):
            type_random_base64_char()
        else:
            move_cursor_randomly()
        time.sleep(5)  # Wait for 5 seconds between actions

# Main function to handle the command-line input and timing logic
def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Control how long the script types random Base64 chars.")
    
    # Add positional arguments for time durations
    parser.add_argument('durations', type=int, nargs='+', help='Durations in minutes for typing or pausing. Example: "30 10 20"')
    
    args = parser.parse_args()

    # Process each duration sequentially
    for index, duration in enumerate(args.durations):
        if index % 2 == 0:
            # Typing duration
            # print(f"Typing for {duration} minute(s)...")
            type_or_move_for_duration(duration)
        else:
            # Pausing duration
            # print(f"Pausing for {duration} minute(s)...")
            time.sleep(duration * 60)

if __name__ == "__main__":
    main()
