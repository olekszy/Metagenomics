for i  in *; do newname=$(echo $i | sed 's/\.[^.]*$//');echo $newname; mv $i $newname; done

