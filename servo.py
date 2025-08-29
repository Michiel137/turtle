from machine import Pin, PWM


class Servo():
    ''' Control position of a hobby servo motor via a PWM capable GPIO pin.
    '''

    def __init__(self, pin_id, position=None):
        ''' Initialize the servo and sets its initial position.

            :param int pin_id: The id of the PWM capable pin attached to the control input of the servo
            :param float position: The control value [0.0 .. 1.0] for the initial position. If None, deactives the servo
        '''
        pin = Pin(pin_id, Pin.OUT)
        self._pwm = PWM(pin, freq=50, duty_u16=self.duty_cycle(position))

    def position(self, value):
        ''' Set the servo position.
            :param float value: The control value [0.0 .. 1.0] for the new position
        '''
        self._pwm.duty_u16(self.duty_cycle(value))

    def deactivate(self):
        ''' Deactivate the servo.
            It will probably keep its position because of friction, but it will not actively maintain it.
        '''
        self._pwm.duty_u16(0)

    @staticmethod
    def duty_cycle(control):
        ''' Convert control value [0.0 .. 1.0] to PWM duty cycle.
        '''
        return int((1 / 20 + 1 / 20 * control) * 65535)
