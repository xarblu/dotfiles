; get proper line editing and history
(ql:quickload :linedit)
(linedit:install-repl :wrap-current t :eof-quits t)
