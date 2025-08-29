from time import sleep
from turtle import Turtle

turtle = Turtle()
# blink leds together 5 times via methods on turtle
for _ in range(5):
    turtle.leds_on()
    sleep(0.5)
    turtle.leds_off()
    sleep(0.5)

# alternate between leds indefinitely by controlling pins directly.
# interrupt with Ctrl-C
turtle.led_left.on()
turtle.led_right.off()
sleep(0.5)
while True:
    turtle.led_left.toggle()
    turtle.led_right.toggle()
    sleep(0.5)
