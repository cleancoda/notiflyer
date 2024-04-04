if object_id('notiflyer_fnUrlEncode') is not null
    print 'notiflyer_fnUrlEncode function exists, skipping create attempt..'
    print 'ignore error below, cannot create exception handling on ddl statements'
    return;
go


create function notiflyer_fnUrlEncode
/*
    @author     cleancoda
    @date       11122023
    @detail     converts passed argument of @url into clean/encoded html format
    @log
                cc  11122023 - generated basic script file
*/
(
    @url varchar(max)
) returns varchar(max)
as
    begin
        -- declare variables
        declare @intCount int,
                @strChar char(1),
                @i int,
                @strUrlReturn varchar(max);

        -- init vars
        set @intCount       = len(@url);
        set @i              = 1;
        set @strUrlReturn   = '';  

        -- loop through all characters
        while (@i <= @intCount)
        begin
            -- get current character
            set @strChar = substring(@url, @i, 1)
            
            -- validate current character for ascii
            -- regex for normal/allowed values for url
            if @strChar like '[A-Za-z0-9()''*-._! ]'
            begin
                -- add current character to existing string
                set @strUrlReturn = @strUrlReturn + @strChar
            end
            else
            -- convert invalid values for url
            begin
                set @strUrlReturn =
                    @strUrlReturn +
                    '%' +
                    -- encode and append character to string
                    -- https://learn.microsoft.com/en-us/sql/t-sql/data-types/binary-and-varbinary-transact-sql?view=sql-server-ver16
                    substring(sys.fn_varbintohexstr(try_cast(@strChar as varbinary(max))),3,2)
            end
            -- fetch next character
            set @i = @i +1
        end
        -- return encoded url string
        return @strUrlReturn
    end
go