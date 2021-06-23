; установка языка операционной системы
("/sysconfig-base/language" action "write" lang ("ru_RU"))
; установка переключателя расладки клавиатуры на Ctrl+Shift
("/sysconfig-base/kbd" action "write" layout "ctrl_shift_toggle")
; установка часового пояса в Europe/Saratov, время в UEFI будет храниться в UTC
("/datetime-installer" action "write" commit #t name "RU" zone "Europe/Saratov" utc #t)

; автоматическая разбивка жёсткого диска
("/evms/control" action "write" control open installer #t)
("/evms/control" action "write" control update)
("/evms/profiles/workstation" action apply commit #f clearall #t exclude ())
("/evms/control" action "write" control commit)
("/evms/control" action "write" control close)

; установка пакетов операционной системы
("pkg-init" action "write")
("/pkg-install" action "write" lists "" auto #t)
("/preinstall" action "write")

; установка пароля root
("/root/change_password" language ("ru_RU") passwd_2 "altlinux" passwd_1 "altlinux")

; задание первого пользователя 'user' с паролем 'user'
("/users/create_account" new_name "test" gecos "" allow_su #t auto #f passwd_1 "test" passwd_2 "test")

; установка загрузчика GRUB-EFI
("/grub" action "write" device "efi" passwd #f passwd_1 "*" passwd_2 "*")

; настройка сетевого интерфейса на получение адреса по DHCP
("/net-eth" action "write" reset #t)
("/net-eth" action "write" name "eth0" ipv "4" configuration "dhcp" default "" search "" dns "" ipv_enabled #t)
("/net-eth" action "write" commit #t)

; выполнить скрипт перед перезагрузкой в установленную ОС
("/postinstall/laststate" script "http://10.42.0.4/altinstall/postinstall.sh")
; выполнить скрипт при первой загрузке установленной ОС.
; XXX: postinstall.d насильно отключает sshd, поэтому разрешить запуск
; sshd в laststate не выйдет.
("/postinstall/firsttime" script "http://10.42.0.4/altinstall/firsttime.sh")
