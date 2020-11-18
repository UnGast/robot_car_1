import NvidiaJetsonGPIO

let controller = NvidiaJetsonGPIOController()

print(controller.headers)

print("GET STATE OF GPIO PIN", controller[gpio: 79])

print("SET STATE OF GPIO PIN")
try controller.set(gpioId: 79, direction: .input)
try controller.set(gpioId: 79, value: .high)