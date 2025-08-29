from time import sleep
from turtle import Turtle

turtle = Turtle()

for _ in range(20):
    turtle.speaker_on(440)
    sleep(0.5)
    turtle.speaker_on(880)
    sleep(0.5)

turtle.speaker_off()
