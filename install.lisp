(in-package lay)

(defun lay_install ( keyword )
  (format t ":: 尝试查找常规源~%")
  (setf code_return (sb-ext:run-program "/usr/bin/pacman" (list "-Si" keyword) :input nil :output *standard-output*))
  (when (= (sb-ext:process-exit-code code_return) 0)
    (format t ":: 可以使用sudo pacman -S ~S安装这个包~%:: 在常规源中找到了包，是否中断构建？[y/n]" keyword)
    (if (string= (read) "N") (format t "~%继续从AUR构建包~%")
        (return-from lay_install 0)
        )
    )
  (setf code_return (sb-ext:run-program "/usr/bin/bash" (list "-c" "if [ ! -d ~/.cache/aur ];then mkdir -p ~/.cache/aur;fi") :input nil :output *standard-output*))
  (trivial-download:download (concatenate 'string "https://aur.archlinux.org/cgit/aur.git/snapshot/" keyword ".tar.gz") "~/.cache/aur/laytmp.tar.gz")
  (setf code_return (sb-ext:run-program "/usr/bin/bash" (list "-c" "tar -xzvf ~/.cache/aur/laytmp.tar.gz -C ~/.cache/aur/") :input nil :output *standard-output*))
  (setf code_return (sb-ext:run-program "/usr/bin/bash" (list "-c" (concatenate 'string "cd ~/.cache/aur/" keyword " && rm *.pkg.tar.zst && makepkg &&mv *.pkg.tar.zst laybuild.pkg.tar.zst")) :input nil :output *standard-output*))
  (when (= (sb-ext:process-exit-code code_return) 0) (princ (concatenate 'string ":: 包构建完成，可以使用sudo pacman -U ~/.cache/aur/" keyword "/laybuild.pkg.tar.zst 进行安装")))
  (terpri)
  )

(defun lay_download ( keyword )
  (format t ":: 尝试查找常规源~%")
  (setf code_return (sb-ext:run-program "/usr/bin/pacman" (list "-Si" keyword) :input nil :output *standard-output*))
  (when (= (sb-ext:process-exit-code code_return) 0)
    (format t ":: 可以使用sudo pacman -S ~S安装这个包~%:: 在常规源中找到了包，是否中断下载？[y/n]" keyword)
    (if (string= (read) "N") (format t "~%继续从AUR下载PKGBUILD~%")
        (return-from lay_download 0)
        )
    )
  (setf code_return (sb-ext:run-program "/usr/bin/bash" (list "-c" "if [ ! -d ~/.cache/aur ];then mkdir -p ~/.cache/aur;fi") :input nil :output *standard-output*))
  (trivial-download:download (concatenate 'string "https://aur.archlinux.org/cgit/aur.git/snapshot/" keyword ".tar.gz") "~/.cache/aur/laytmp.tar.gz")
  (setf code_return (sb-ext:run-program "/usr/bin/bash" (list "-c" "tar -xzvf ~/.cache/aur/laytmp.tar.gz -C ~/.cache/aur/") :input nil :output *standard-output*))
  (when (= (sb-ext:process-exit-code code_return) 0) (princ (concatenate 'string ":: PKGBUILD下载完成，请在 ~/.cache/aur/" keyword " 查看")))
  (terpri)
  )
