#!/bin/bash

cd CSharp/src/

if test "$OS" = "Windows_NT"
then
  # use .Net

  .paket/paket.bootstrapper.exe
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
  	exit $exit_code
  fi

  .paket/paket.exe restore
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
  	exit $exit_code
  fi
  
  [ ! -e build.fsx ] && .paket/paket.exe update
  [ ! -e build.fsx ] && packages/FAKE/tools/FAKE.exe ../scripts/init.fsx
  packages/FAKE/tools/FAKE.exe $@ --fsiargs -d:MONO ../scripts/build.fsx 
else
  # use dotnet core
  dotnet run .paket/paket.bootstrapper.exe
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
  	exit $exit_code
  fi

  dotnet run .paket/paket.exe restore
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
  	exit $exit_code
  fi

  [ ! -e build.fsx ] && dotnet run .paket/paket.exe update
  [ ! -e build.fsx ] && dotnet run packages/FAKE/tools/FAKE.exe ../scripts/init.fsx
  dotnet run packages/FAKE/tools/FAKE.exe $@ --fsiargs -d:MONO ../scripts/build.fsx 
fi