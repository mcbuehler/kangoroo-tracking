function debug( msg, args )

if getenv('DEBUG') == '1'
    fprintf(msg,args);
end

end

