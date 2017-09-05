;;  EMACS INIT FILE FOR GNU Emacs 24
;;  @author mozcelikors <mozcelikors@gmail.com>

;; I use leuven theme since it is good-looking with 'tabbar', that is what is set below automatically..

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (leuven))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Maximize GNU Emacs on start-up
;;(add-to-list 'default-frame-alist '(fullscreen . maximized))
(defun fullscreen (&optional f)
	(interactive)
	(x-send-client-message nil 0 nil "_NET_WM_STATE" 32
		'(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
	(x-send-client-message nil 0 nil "_NET_WM_STATE" 32
		'(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))

(fullscreen)
;; Be sure to give ~/.emacs ~/.emacs.d/ great permissions for avoiding *warnings* window. (777)

;; We use Wanderlust for E-mail client..
;; Make sure to download it using apt-get install wl gnutls-bin
;; Now, create ~/.folders with the following content:
;; %inbox "inbox"
;; +trash "Trash"
;; +draft "Drafts"
;; Be sure to configure Google to allow less secure apps via:
;; https://www.google.com/settings/security/lessecureapps
;; Using the configuration now M-x wl will open Wanderlust
;; The following is the configuration for Wanderlust, IMAP, and SMTP.
;; wanderlust
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; IMAP, gmail:
(setq elmo-imap4-default-server "imap.gmail.com"
	elmo-imap4-default-user "mozcelikors@gmail.com"
	elmo-imap4-default-authenticate-type 'clear
	elmo-imap4-default-port '993
	elmo-imap4-default-stream-type 'ssl

	;; For non ascii-characters in folder-names
	elmo-imap4-use-modified-utf7 t)

;; SMTP
(setq wl-smtp-connection-type 'starttls
	wl-smtp-posting-port 587
	wl-smtp-authenticate-type "plain"
	wl-smtp-posting-user "mozcelikors"
	wl-smtp-posting-server "smtp.gmail.com"
	wl-local-domain "gmail.com"
	wl-message-id-domain "smtp.gmail.com")

(setq wl-from "Mustafa Özçelikörs <mozcelikors@gmail.com>"
	;; All system folders (draft, trash, spam, etc) are placed in the
	;; [Gmail]-folder, except inbox. "%" means it's an IMAP-folder
	wl-default-folder "%inbox"
	wl-draft-folder   "%[Gmail]/Drafts"
	wl-trash-folder   "%[Gmail]/Trash"
	;; The below is not necessary when you send mail through Gmail's SMTP server,
	;; see https://support.google.com/mail/answer/78892?hl=en&rd=1
	;; wl-fcc            "%[Gmail]/Sent"

	;; Mark sent messages as read (sent messages get sent back to you and
	;; placed in the folder specified by wl-fcc)
	wl-fcc-force-as-read    t

	;; For auto-completing foldernames
	wl-default-spec "%")


;; If you want to use Gnus (Another Gmail Client) to access Gmail, set up the following
;; Be sure to configure Google to allow less secure apps via:
;; https://www.google.com/settings/security/lessecureapps
;; ~/.gnus
;(setq user-mail-address "<EMAIL_ADDRESS>"
;	user-full-name "<FULL NAME>")
;
;(setq gnus-select-method
;	'(nnimap "gmail"
;		(nnimap-address "imap.gmail.com")  ; it could also be imap.googlemail.com if that's your server.
;		(nnimap-server-port "imaps")
;		(nnimap-stream ssl)))
;
;(setq smtpmail-smtp-server "smtp.gmail.com"
;	smtpmail-smtp-service 587
;	gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")


;; ~/.authinfo
;machine imap.gmail.com login <EMAIL> password <PASSWORD> port imaps
;machine smtp.gmail.com login <EMAIL> password <PASSWORD> port 587


;; Open wanderlust for retrieving E-mails once Emacs starts
;(wl)


;; Create a dired buffer, the Directory Editor for on the side use.
(dired "/home/mozcelikors/")

;; Start a few shells, with specified directories
(let ((default-directory "/home/mozcelikors/"))
	(shell "*shell"))

(let ((default-directory "/media/sf_Ubuntu_Shared/MyGitHub/"))
	(shell "*shell1"))

(let ((default-directory "/home/mozcelikors/"))
	(shell "*shell2"))

;; Switch buffer to the created shell after Emacs launches
(add-hook 'emacs-startup-hook
	(lambda () when (cl-notany 'buffer-file-name (buffer-list))
		(switch-to-buffer
			(generate-new-buffer-name "*shell3"))))

;; When editing tex files in tex-mode, you may want to create another buffer for the pdf, in DocView. We want DocView to be continous, to scroll pages easily. Therefore, we set it to true 't' as opposed to false 'nil'
(setq doc-view-continuous t)

;; Split the window to our use.. C-x 3  + C-x 2 + then, switch buffers
(split-window-right)
(switch-to-buffer "*shell") ; Switch buffer to other shell that we have created
(split-window-below)
(switch-to-buffer "*shell1")  ; Switch buffer to other shell that we have created

;; Load tabbar-2.0.1 from https://marmalade-repo.org/packages/tabbar-2.0.1.el, put in ~/.emacs.d
;; We access to it here
(load-file "~/.emacs.d/tabbar-2.0.1.el")
(tabbar-mode)
;; Define our navigation keys for between tabs
(global-set-key (kbd "C-c <right>") 'tabbar-forward-tab)
(global-set-key (kbd "C-c <left>") 'tabbar-backward-tab)

;; Load the ssh client we use from https://github.com/ieure/ssh-el/blob/master/ssh.el
(load-file "~/.emacs.d/ssh.el")
