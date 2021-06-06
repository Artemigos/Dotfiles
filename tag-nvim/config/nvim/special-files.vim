" au! BufWritePost $MYVIMRC source $MYVIMRC " coloring breaks because of this
au! BufRead tridactylrc set foldmethod=marker
au! BufRead tridactylrc set foldmarker=\"{,}\"

