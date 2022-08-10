@echo off
	mode 80, 25
	color 8E
setlocal EnableDelayedExpansion

:tela_inicial

echo -----------------------                                                       -
echo - Incluir Usuario   (I)                                                       -
echo -----------------------                                                       -
echo - Editar Usuario    (E)                                                       -
echo -----------------------                                                       -
echo - Localizar Usuario (L)                                                       -
echo -----------------------                                                       -
echo - Deletar Usuario   (D)                                                       -
echo -----------------------                                                       -
echo - Visualizar Tudo   (V)                                                       -
echo -----------------------                                                       -
echo.						
echo.
echo.
echo.
echo -----------------------                                                       -
echo - Sair              (S)                                                       -
echo -----------------------                                                       -
echo.
set /p choice=:


if /i %choice% equ i (
					cls
					goto :incluir
					)
if /i %choice% equ e (
					cls
					goto :editar
					)
if /i %choice% equ l (
					cls
					goto :localizar
					)
if /i %choice% equ d (
					cls
					goto:deletar
					)
if /i %choice% equ v (
					cls
					goto:visualizar
					)
if /i %choice% equ s (
					cls
					goto:sair
					)

::incluir_ield

:incluir

goto :name
   
:name

	echo Digite seu nome: 
	set /p nome=:
	cls

	echo Digite seu sobrenome: 
	set /p sobrenome=:
	cls
																				
:age
	echo Digite sua data de nascimento: (dd/mm/aaaa) 
	set /p nasc=:
	
	set /a ano=%date:~6,4%-%nasc:~6,4%
	set MesDiaAtual=%date:~3,2%%date:~0,2%
	set MesDiaNasc=%nasc:~3,2%%nasc:~0,2%

	if %MesDiaAtual% geq %MesDiaNasc% (set /a idade=%ano%) else (set /a idade=%ano%-1)
	
	cls
	
	if %idade% lss 18 (
						echo Precisas ter 18 anos ou mais para se cadastrar...
						pause>nul
						cls
						goto :age
						) else (goto :pk)

:pk
	echo Digite seu CPF: (***.***.***-**)
	set /p cpf=:
	cls

	echo ------------------------
	echo NOME: %nome% %sobrenome%
	echo ------------------------
	echo IDADE: %idade%
	echo ------------------------
	echo CPF: %cpf%
	echo ------------------------
	echo.
	
	echo Confirmar dados? (sim/nao)
	set /p yn=:

	if %yn% equ sim (
					cls
					>>UsersDatabase.csv echo %nome% %sobrenome%;%nasc%;%cpf%
					echo Dados cadastrados com sucesso^^!
					) else (
							cls
							goto :name
							)

goto :end

::editar_ield

:editar

cls
echo Digite o CPF do usuario:
set /p cpf_edit=:

set sucess=
for /f "tokens=1-4 delims=; " %%a in (UsersDatabase.csv) do if /i "%cpf_edit%" equ "%%d" (	
																						cls
																						echo %%a %%b - %%c - %%d
																						set sucess=s
																							)
if not "%sucess%" equ "s" (
	 						cls
	 						echo -------------------------------------------------------------------------------
	 						echo.
							echo Erro^^!
							echo.
							echo.
							echo O usuario nao existe em nosso sistema. Por favor, aperte ENTER para novamente.
							echo.
							echo -------------------------------------------------------------------------------
							pause>nul
							goto :editar
							)

echo.
echo ------------------------
echo Qual dado deseja editar?
echo.
echo 1 - Nome 
echo.
echo 2 - Data 
echo.
echo 3 - CPF
echo.
echo ------------------------
set /p dado_edit=:
cls

for /f "tokens=1-4 delims=; " %%a in ('type UsersDatabase.csv ^| find /i /v "" ') do if %%d equ %cpf_edit% (>>UserInfo.tmp echo %%a;%%b;%%c;%%d) 

if %dado_edit% equ 1 (goto :nome_edit)
if %dado_edit% equ 2 (goto :data_edit)
if %dado_edit% equ 3 (goto :cpf_edit)

:nome_edit

	for /f "tokens=1-4 delims=; " %%a in ('type UsersDatabase.csv ^| find /i /v "" ') do if not %%d equ %cpf_edit% (>>UsersDatabase.tmp echo %%a %%b;%%c;%%d)

	echo Digite o novo nome do usuario:
	set /p new_name=
	echo.
	echo Digite o novo sobrenome do usuario:
	set /p new_sn=

	for /f "tokens=1-4 delims=; " %%a in ('type UserInfo.tmp ^| find /i /v "" ') do if %%d equ %cpf_edit% (>>UsersDatabase.tmp echo %new_name% %new_sn%;%%c;%%d)

	goto :del_tmp
 

:data_edit

	for /f "tokens=1-4 delims=; " %%a in ('type UsersDatabase.csv ^| find /i /v "" ') do if not %%d equ %cpf_edit% (>>UsersDatabase.tmp echo %%a %%b;%%c;%%d)

	echo Digite a nova data de nascimento do usuario:
	set /p new_date=

	for /f "tokens=1-4 delims=; " %%a in ('type UserInfo.tmp ^| find /i /v "" ') do if %%d equ %cpf_edit% (>>UsersDatabase.tmp echo %%a %%b;%new_date%;%%d)

	goto :del_tmp

:cpf_edit

	for /f "tokens=1-4 delims=; " %%a in ('type UsersDatabase.csv ^| find /i /v "" ') do if not %%d equ %cpf_edit% (>>UsersDatabase.tmp echo %%a %%b;%%c;%%d)

	echo Digite o novo CPF do usuario:
	set /p new_cpf=:

	for /f "tokens=1-4 delims=; " %%a in ('type UserInfo.tmp ^| find /i /v "" ') do if %%d equ %cpf_edit% (>>UsersDatabase.tmp echo %%a %%b;%%c;%new_cpf%)

	goto :del_tmp

:del_tmp
	cls
	echo Dados atualizados com sucesso^^!
	del UsersDatabase.csv
	del UserInfo.tmp
	ren "UsersDatabase.tmp" "UsersDatabase.csv"

goto :end

::localizar_ield

:localizar

cls
echo Digite o CPF do usuario:
set /p cpf_search=:


set sucess2=
for /f "tokens=1-9 delims=; " %%a in (UsersDatabase.csv) do (if %cpf_search% equ %%d (
																						cls
																						echo -------------------------------------------------
																						echo.
																						echo Nome: %%a %%b 
																						echo.
																						echo -------------------------------------------------
																						echo.
																						echo Data de nascimento: %%c 
																						echo.
																						echo -------------------------------------------------
																						echo.
																						echo CPF: %%d
																						echo.
																						echo -------------------------------------------------
																						set sucess2=s
																						))

if not "%sucess2%" equ "s" (
 						cls
 						echo -------------------------------------------------------------------------------
 						echo.
						echo Erro^^!
						echo.
						echo.
						echo O usuario nao existe em nosso sistema. Por favor, aperte ENTER para novamente.
						echo.
						echo -------------------------------------------------------------------------------
						pause>nul
						goto :localizar
									)

										

goto :end

::deletar_ield

:deletar

cls
echo Qual usuario deseja deletar? (CPF)
set /p del_user=:
cls

set sucess3=
for /f "tokens=1-4 delims=; " %%a in (UsersDatabase.csv) do (if %del_user% equ %%d (
																					echo %%a %%b - %%c - %%d
																					set sucess3=s
																					))
if not "%sucess3%" equ "s" (
 						cls
 						echo -------------------------------------------------------------------------------
 						echo.
						echo Erro^^!
						echo.
						echo.
						echo O usuario nao existe em nosso sistema. Por favor, aperte ENTER para novamente.
						echo.
						echo -------------------------------------------------------------------------------
						pause>nul
						goto :deletar
									)

echo.
echo ----------------------------------------
echo Confirmar exclusao de usuario? (sim/nao)
echo.
echo ----------------------------------------
set /p yn_del=:

if %yn_del% equ sim (goto :delete)

:delete

for  /f "tokens=1-4 delims=; " %%a in ('type UsersDatabase.csv ^| find /i /v "" ') do if not %%d equ %del_user% (>>UsersDatabase.tmp echo %%a %%b;%%c;%%d)

del UsersDatabase.csv
ren "UsersDatabase.tmp" "UsersDatabase.csv"

cls
echo Dados do usuario apagados com sucesso^^!

goto :end

:visualizar

for /f "tokens=1-4 delims=; " %%a in (UsersDatabase.csv) do (
															echo %%a %%b - %%c - %%d
															echo.
															)


::fim_ield

:end

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo -------------------------------------------------
echo.
echo Aperte ENTER para voltar ao menu inicial.
echo.
echo -------------------------------------------------

pause >nul
cls
goto :tela_inicial

:sair

exit