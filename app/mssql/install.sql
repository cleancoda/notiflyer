/*
    @author:    cleancoda
    @date:      10102023
    @desc:      script to automate running various required 
                sql scripts to create and configure sql tables
                required for notiflyer app in destination database
    @log:
            cc  10102023 - generated basic script file
*/

-- enable xp_cmdshell
exec master..sp_configure 'show advanced options',1;
reconfigure with override;
go
exec master..sp_configure 'xp_cmdshell',%ENABLE%;
reconfigure with override;
go
exec master..sp_configure 'show advanced options',0;
reconfigure with override;
go

-- enable spOA methods
exec master..sp_configure 'show advanced options',1;
reconfigure with override;
go
exec master..sp_configure 'ole automation procedures',1;
reconfigure with override;
go