require "copy";
require "mailbox";
require "imap4flags";
require "fileinto";

if anyof (header :contains "List-Id" "devel.lists.altlinux.org",
    header :contains "Subject" "[devel]") { fileinto :create "Inbox/altlinux-devel"; }
elsif anyof (header :contains "List-Id" "rebase.lists.altlinux.org",
    header :contains "Subject" "[rebase]") { fileinto :create "Inbox/rebase"; }
elsif anyof (header :contains "List-Id" "saratov.lists.altlinux.org",
    header :contains "Subject" "[Saratov]") { fileinto :create "Inbox/Saratov"; }
elsif header :contains "List-Id" "redmine.basealt.ru" { fileinto :create "Inbox/Tickets"; }
elsif anyof (header :contains "List-Id" "samba.lists.samba.org",
             header :contains "Subject" "[Samba]") { fileinto :create "Inbox/Samba"; }
elsif anyof (header :contains "List-Id" "arm64-baikalm.lists.altlinux.org",
             header :contains "Subject" "[Arm64-baikalm]",
             header :contains "Subject" "[Alt-baikal]") { fileinto :create "Inbox/Baikal"; }
elsif header :contains "Subject" "FOO-BAR-BAZZ" { fileinto :create "Inbox/TEST"; }
else { keep; }
