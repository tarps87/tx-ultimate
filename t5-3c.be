    def TXUltimate_Short(value, trigger, msg)
        print("message:")
        print(msg)
        var Channel = msg['TXUltimate']['Channel']
        if Channel <= 3
            tasmota.cmd('Power1 2')
            tasmota.cmd('SelectLeft 2')
        elif Channel >3 && Channel < 8
            tasmota.cmd('Power2 2')
            tasmota.cmd('SelectMid 2')
        else
            tasmota.cmd('Power3 2')
            tasmota.cmd('SelectRight 2')
        end
        tasmota.cmd('Buzzer 1,2')
    end

    def TXUltimate_Action(value, trigger, msg)
        print("message:")
        print(msg)
        var Action = msg['TXUltimate']['Action']
        if Action == 'Swipe right'
            tasmota.cmd('Power1 1')
            tasmota.cmd('SelectLeft 1')
            tasmota.cmd('Power2 1')
            tasmota.cmd('SelectMid 1')
            tasmota.cmd('Power3 1')
            tasmota.cmd('SelectRight 1')
            tasmota.cmd('Buzzer 1,2')
        elif  Action == 'Swipe left'
            tasmota.cmd('Power1 0')
            tasmota.cmd('SelectLeft 0')
            tasmota.cmd('Power2 0')
            tasmota.cmd('SelectMid 0')
            tasmota.cmd('Power3 0')
            tasmota.cmd('SelectRight 0')
            tasmota.cmd('Buzzer 1,2')
        end
    end

    def Right_On(led, power)
        var color = 0x000000
        if(power)
            color = 0xFFFFFF
        end

        led.set_pixel_color(26, color)
        led.set_pixel_color(27, color)
        led.set_pixel_color(0, color)
        led.set_pixel_color(1, color)
        led.set_pixel_color(2, color)
        led.set_pixel_color(3, color)
        led.set_pixel_color(4, color)
        led.set_pixel_color(5, color)
        led.set_pixel_color(6, color)
    end

    def Mid_On(led, power)
        var color = 0x000000
        if(power)
            color = 0xFFFFFF
        end

        led.set_pixel_color(25, color)
        led.set_pixel_color(24, color)
        led.set_pixel_color(23, color)
        led.set_pixel_color(22, color)
        led.set_pixel_color(7, color)
        led.set_pixel_color(8, color)
        led.set_pixel_color(9, color)
        led.set_pixel_color(10, color)
        led.set_pixel_color(11, color) 
    end

    def Left_On(led, power)
        var color = 0x000000
        print("LEFT!!!")
        print(power)
        if(power)  
            color = 0xFFFFFF
        end

        led.set_pixel_color(20, color)
        led.set_pixel_color(19, color)
        led.set_pixel_color(18, color)
        led.set_pixel_color(17, color)
        led.set_pixel_color(16, color)
        led.set_pixel_color(15, color)
        led.set_pixel_color(14, color)
        led.set_pixel_color(13, color)
        led.set_pixel_color(12, color)   
    end

    def Update_Leds()
        print("led update")
        var led = Leds(28, 13)

        import persist

        Left_On(led, persist.member("left"))
        Mid_On(led, persist.member("mid"))
        Right_On(led, persist.member("right"))

        led.show()
    end

    def Select_Left(cmd, idx, payload, payload_json)
        import persist

        if(payload == "2")
            persist.left = !(persist.member("left") == true)
        else
            persist.left = payload == "1"
        end
        persist.save()

        Update_Leds()

        tasmota.resp_cmnd_done()
    end

    def Select_Mid(cmd, idx, payload, payload_json)
        import persist

        if(payload == "2")
            persist.mid = !(persist.member("mid") == true)
        else
            persist.mid = payload == "1"
        end
        persist.save()

        Update_Leds()

        tasmota.resp_cmnd_done()
    end

    def Select_Right(cmd, idx, payload, payload_json)
        import persist

        if(payload == "2")
            persist.right = !(persist.member("right") == true)
        else
            persist.right = payload == "1"
        end
        persist.save()

        Update_Leds()

        tasmota.resp_cmnd_done()
    end

    tasmota.add_cmd("SelectLeft", Select_Left)
    tasmota.add_cmd("SelectMid", Select_Mid)
    tasmota.add_cmd("SelectRight", Select_Right)

    tasmota.remove_rule("TXUltimate#Action=Short", "TXUltimate_Short")
    tasmota.add_rule("TXUltimate#Action=Short", TXUltimate_Short, "TXUltimate_Short")

    tasmota.remove_rule("TXUltimate#Action", "TXUltimate_Action")
    tasmota.add_rule("TXUltimate#Action", TXUltimate_Action, "TXUltimate_Action")
