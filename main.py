from bottle import route, run
import math


@route('/')
def index():
    x = 0.0001
    for i in range(0, 1000000):
        x += math.sqrt(i)
    return "OK: {}".format(x)


if __name__ == '__main__':
    run(host='0.0.0.0', port=80)
