from time import sleep
from turtle import Turtle

turtle = Turtle()
turtle.speed(20)
turtle.forward_continuously()

while turtle.button() != 0:
    if turtle.sensor_left() < 32768:
        turtle.back(50)
        turtle.right(90)
        turtle.forward_continuously()
    elif turtle.sensor_right() < 32768:
        turtle.back(50)
        turtle.left(90)
        turtle.forward_continuously()
    else:
        sleep(0.1)
        
turtle.stop()
