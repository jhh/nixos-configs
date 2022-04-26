bind \cr _fzf_search_history

if not functions -q __direnv_export_eval; and command -sq direnv
    direnv hook fish | source
end

set --local WPI_YEAR 2022
if test -d ~/wpilib/$WPI_YEAR
    abbr --add --global pathweaver ~/wpilib/$WPI_YEAR/tools/PathWeaver.py
    abbr --add --global outlineviewer ~/wpilib/$WPI_YEAR/tools/OutlineViewer.py
    set --export JAVA_HOME ~/wpilib/$WPI_YEAR/jdk
    fish_add_path $JAVA_HOME/bin
end