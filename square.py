from time import sleep
from turtle import Turtle

# initialize turtle with calibration values
turtle = Turtle(wheel_circumference=158.7, track_width=77.5, pen_up_position=0.5, pen_down_position=0.1)
turtle.speed(20)

# wait until the button is pressed
while turtle.button() != 0:
    sleep(0.1)

turtle.leds_on()

# draw a square
for _ in range(4):
    turtle.pendown()
    turtle.forward(50)
    turtle.penup()
    turtle.left(90)

# done
turtle.speaker_on(440)
sleep(1.0)
turtle.speaker_off()

turtle.leds_off()
