from machine import Pin, Timer


class Stepper:
    ''' Control a unipolar stepper motor like the 28BYJ-48 via a driver like
        the ULN2003 directly connected to 4 microcontroller GPIO pins.
    '''

    FORWARD = 1
    BACK = -1

    def __init__(self, pin_ids):
        ''' Initialize the stepper.
            :param int pin_ids: The ids of the 4 control pins connected the inputs of the driver IC
        '''
        self._pins = [Pin(pin_ids[i], mode=Pin.OUT, value=0) for i in range(4)]
        # wave steps: only on coil is active at a time
        #self._step_sequence = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
        # full steps: two coils are active at a time
        self._step_sequence = [[1, 1, 0, 0], [0, 1, 1, 0], [0, 0, 1, 1], [1, 0, 0, 1]]
        self._step_index = 0
        self._timer = Timer()
        self._moving = False

    @property
    def is_moving(self):
        ''' Return whether the stepper is moving.
        '''
        return self._moving

    def move(self, direction, speed, count=None):
        ''' Move the stepper motor.

            :param int direction: The direction (Stepper.FORWARD=1 or Stepper.BACK=-1) to move in
            :param int speed: Number of steps per second
            :param int count: The number of steps, or None to run continuously
        '''
        self.stop()
        self._step_direction = int(direction)
        self._step_count = None if count is None else int(count)
        self._timer.init(mode=Timer.PERIODIC, freq=speed, callback=self._update)
        self._moving = True

    def stop(self):
        ''' Stop moving the stepper.
        '''
        self._timer.deinit()
        self._moving = False

    def deactivate(self):
        ''' Stop moving the stepper and deactivate it.
        '''
        self.stop()
        for pin_index in range(len(self._pins)):
            self._pins[pin_index].value(0)

    def _step(self):
        ''' Make a single step in the set direction.
        '''
        self._step_index = (self._step_index + self._step_direction) % len(self._step_sequence)
        for pin_index in range(len(self._pins)):
            self._pins[pin_index].value(self._step_sequence[self._step_index][pin_index])

    def _update(self, _):
        ''' Timer callback.
        '''
        if self._step_count is None:
            self._step()
        elif self._step_count > 0:
            self._step()
            self._step_count -= 1
        else:
            self._moving = False


if __name__ == '__main__':
    from time import sleep
    # motor = Stepper([5, 4, 3, 2])  # left motor
    motor = Stepper([11, 10, 9, 8])  # right motor
    motor.move(1, 500, 2048)

    while motor.is_moving:
        sleep(0.1)

    motor.deactivate()
