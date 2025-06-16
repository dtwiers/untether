Logger.configure(level: :debug)
ExUnit.start(assert_receive_timeout: 1000, capture_log: true)


# For Registry to sync...maybe? Ask ChatGPT. Seems premature but I can pay 10ms for it.
Process.sleep(10)


