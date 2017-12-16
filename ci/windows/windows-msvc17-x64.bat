call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
set PATH=C:\Qt\5.10.0\msvc2017_64\bin;%PATH%
mkdir build-win64-vs
cd build-win64-vs
echo %PATH%
qmake.exe CONFIG+=release CONFIG+=with_update_service ..\
nmake
mkdir bin
copy app\release\OpenTodoList.exe bin
copy ..\pre-build\windows\openssl-1.0.2l-x64_86-win64\ssleay32.dll bin\ssleay32.dll
copy ..\pre-build\windows\openssl-1.0.2l-x64_86-win64\libeay32.dll bin\libeay32.dll
windeployqt --qmldir ..\app --release --compiler-runtime bin\OpenTodoList.exe
