#!/bin/sh

function exportGitGraph(){

  touch gitlog.txt
  chmod 755 gitlog.txt
  git log \
    --date-order \
    -p -999 \
    --full-history \
    --simplify-merges \
    --decorate=no \
    --objects \
    --format=format:'--START--<spanclass="subject">%B</span>%n''<spanclass="date">%ai</span>%n''<spanclass="author">%an</span>%n''<spanclass="hash">%T</span>%n''<spanclass="body">%b</span>%n' \
    --all  > gitlog.txt

    #'<spanclass="body">%b</span>%n'
    #  --no-merges --dense
    #--abbrev-commit \
    # --full-diff \
    # --branches=dev\
    # --graph \

  # sed -i "s/<.*@.*>//g" gitlog.txt
  sed -i 's/\s/\&nbsp;/g' gitlog.txt #convert white space to &nbsp;
  sed -i 's/spanclass/span class/g' gitlog.txt # convert 'spanclass' to 'span class'
  sed -i ':a;N;$!ba;s/\n/<br>\n/g' gitlog.txt # convert newline to br ł http://stackoverflow.com/questions/1251999/sed-how-can-i-replace-a-newline-n
  sed -i 's/--START--/<\/div><div class="commit">/g' gitlog.txt
  # sed -i 's/divclass/div class/g' gitlog.txt # convert 'spanclass' to 'span class'
  # diff = grep '<span class=""></span>'

  gitlog=`cat gitlog.txt`
  html_body+='<section id="gitlog">
  <div class="inner">
  '"$gitlog"'
  </div>
  </section>';
  rm gitlog.txt
}


html_index_files=`cat ./site/templates/header.tpl.html`

html_body='<body>
';

exportGitGraph

html_body+='</body>
';

html_index_files+="$html_body"
html_index_files+=`cat ./site/templates/footer.tpl.html`

echo "$html_index_files" > ./site/index.html
