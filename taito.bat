@echo off

set taito_image="taitounited/taito-cli:latest"
set taito_command=%1
set taito_project_path=%cd%
set taito_cli_path=%~dp0
set taito_config_path=%HOMEDRIVE%%HOMEPATH%\.taito
set taito_extension_path=%taito_config_path%\my-extension

IF "%taito_command%"=="--upgrade" (
  cd "%taito_cli_path%"
  git pull
  cd "%taito_extension_path%"
  git pull
  cd "%taito_project_path%"
  docker pull "%taito_image%"
) ELSE (
  docker run -it ^
    -v "%taito_config_path%:/root/.taito" ^
    -v "%taito_project_path%:/project" ^
    -w /project ^
    -e taito_enabled_extensions="%taito_extension_path%" ^
    -e taito_host_uname="Windows" ^
    -e taito_mode="normal" ^
    -e taito_docker="true" ^
    -e taito_image_name="%taito_image%" ^
    --entrypoint "taito" ^
    --rm "%taito_image%" ^
    "%*"
)
