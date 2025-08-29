from machine import ADC, Pin, PWM
from math import copysign, pi
from servo import Servo
from stepper import Stepper
from time import sleep


class Turtle:
    ''' Control a turtle robot.
    '''

    ## The number of steps for a stepper motor to make one revolution
    STEPS_PER_REVOLUTION = 2048

    def __init__(self, wheel_circumference=None, track_width=None, pen_up_position=None, pen_down_position=None):
        ''' Initialize the turtle.

            :param float wheel_circumferce: Distance in millimeters the turtle will travel with one wheel rotation
            :param float track_width: Distance in millimeters between the wheels
            :param float pen_up_position: The servo control value (0..1) for the pen up position
            :param float pen_down_position: The servo control value (0..1) for the pen down position
        '''
        self._wheel_circumference = 158.7 if wheel_circumference is None else wheel_circumference
        self._track_width = 77.5 if track_width is None else track_width
        self._pen_up_position = 0.5 if pen_up_position is None else pen_up_position
        self._pen_down_position = 0.1 if pen_down_position is None else pen_down_position
        ## The speed in millimeters per second the turtle will travel at.
        self._speed = 20.0
        
        self._servo_pen = Servo(18, self._pen_up_position)
        self._stepper_right = Stepper([11, 10, 9, 8])
        self._stepper_left = Stepper([5, 4, 3, 2])
        self._steps_per_millimeter = self.STEPS_PER_REVOLUTION / self._wheel_circumference

        pin_speaker = Pin(14, mode=Pin.OUT, value=0)
        self._pwm_speaker = PWM(pin_speaker)

        self.led_left = Pin(12, mode=Pin.OUT, value=0)
        self.led_right = Pin(7, mode=Pin.OUT, value=0)
        self.button = Pin(15, mode=Pin.IN, pull=Pin.PULL_UP)
        
        self.ir_left = Pin(13, mode=Pin.OUT, value=1)  # on by default
        self.ir_right = Pin(6, mode=Pin.OUT, value=1)  # on by default
        Pin(27, mode=Pin.IN, pull=None)
        self._adc_left = ADC(27)
        Pin(28, mode=Pin.IN, pull=None)
        self._adc_right = ADC(28)

    @property
    def is_moving(self):
        ''' Return whether the turtle is moving.
        '''
        return self._stepper_right.is_moving or self._stepper_left.is_moving

    def speed(self, value):
        ''' Set the speed the turtle will travel at in millimeters per second.
        '''
        self._speed = value

    def pendown(self):
        ''' Move the pen down so it touches the surface.
        '''
        self._servo_pen.position(self._pen_down_position)
        sleep(0.2)

    def penup(self):
        ''' Move the pen up so it clears the surface.
        '''
        self._servo_pen.position(self._pen_up_position)
        sleep(0.2)

    def forward(self, distance):
        ''' Move the turtle forward.
            :param float distance: The distance to move in millimeters
        '''
        self._move_wheels(+distance, +distance)

    def back(self, distance):
        ''' Move the turtle back.
            :param float distance: The distance to move in millimeters
        '''
        self._move_wheels(-distance, -distance)

    def left(self, angle):
        ''' Turn the turtle left.
            :param float angle: The amount to turn
        ''' 
        self.turn(+angle)

    def right(self, angle):
        ''' Turn the turtle right.
            :param float angle: The amount to turn
        ''' 
        self.turn(-angle)

    def turn(self, angle):
        ''' Turn the turtle.
            :param float angle: The amount to turn. A positive angle turns the turtle right
        ''' 
        distance = angle / 360 * self._track_width * pi
        self._move_wheels(+distance, -distance)

    def forward_continuously(self):
        ''' Move the turtle forward until told otherwise.
        '''
        steps_per_second = round(self._speed * self._steps_per_millimeter)
        self._stepper_right.move(-1, steps_per_second)
        self._stepper_left.move(+1, steps_per_second)

    def stop(self):
        ''' Stop the turtle.
        '''
        self._stepper_right.stop()
        self._stepper_left.stop()

    def _move_wheels(self, distance_right, distance_left):
        ''' Move the turtle.
            :param float distance_right: The distance in millimeters the left wheel has to move
            :param float distance_left: The distance in millimeters the left wheel has to move
            Waits until the movement is done.
        '''
        steps_right, direction_right = self._step_direction(distance_right)
        steps_left, direction_left = self._step_direction(distance_left)
        steps_per_second = round(self._speed * self._steps_per_millimeter)
        self._stepper_right.move(-direction_right, steps_per_second, steps_right)
        self._stepper_left.move(+direction_left, steps_per_second, steps_left)
        while self.is_moving:
            sleep(0.1)

    def _step_direction(self, distance):
        ''' Convert a distance in millimeters (positive or negative) into a number of steps and a direction.
        '''
        steps = round(abs(distance) * self._steps_per_millimeter)
        direction = copysign(1, distance)
        return steps, direction

    def speaker_on(self, frequency):
        ''' Turn the speaker on.
            :param int frequency: The frequency of the tone to generate
        '''
        self._pwm_speaker.init(freq=frequency, duty_u16=32767)

    def speaker_off(self):
        ''' Turn off the speaker.
        '''
        self._pwm_speaker.deinit()

    def leds_on(self):
        ''' Turn on both leds.
        '''
        self.led_left.on()
        self.led_right.on()

    def leds_off(self):
        ''' Turn off both leds.
        '''
        self.led_left.off()
        self.led_right.off()
        
    def sensor_left(self):
        ''' Read the left sensor.
            :return: The value of the sensor [0..65535]
            0 = lots of (infrared) light detected.
            65535 = no (infrared) light detected.
        '''
        return self._adc_left.read_u16()

    def sensor_right(self):
        ''' Read the right sensor.
            :return: The value of the sensor [0..65535]
            0 = lots of (infrared) light detected.
            65535 = no (infrared) light detected.
        '''
        return self._adc_right.read_u16()
