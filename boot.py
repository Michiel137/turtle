def connect(hostname, ssid, pwd):
    import network
    network.hostname(hostname)
    sta_if = network.WLAN(network.STA_IF)
    if not sta_if.isconnected():
        print('connecting to network...')
        sta_if.active(True)
        sta_if.connect(ssid, pwd)
        while not sta_if.isconnected():
            pass
    print('network config:', sta_if.ifconfig())

    import webrepl
    webrepl.start()

    from machine import Pin, Timer
    led = Pin('LED', Pin.OUT)
    Timer(freq=2.5, mode=Timer.PERIODIC, callback=lambda _: led.toggle())


connect('turtle', '<SSID>', '<PASSWORD>')
