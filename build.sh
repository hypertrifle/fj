#!/bin/bash          
          echo Building
          build=$(haxe build.hxml)
          if [[ $? != 0 ]]; then
          	echo Halting
          else
          	nekotools boot fj.n
          	echo Running
          	./fj Hello fj er
          fi
         