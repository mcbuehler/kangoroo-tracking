conf

%get folders
folder = dir (ptbPath);

%remove '.' and '..'
folder = folder (3:end);

foldernames = {folder.name} ;
%set(handles.popDisplay,'String',temp_cellstr);


for i = 1:numel(foldernames)
        videonameEuclid = strcat(foldernames{i});
    videonameSVM = strcat(foldernames{i});
      
    
    disp(strcat('start svm for ',foldernames(i)));
    run_ptb_function(videonameSVM,int8(5),int8( 1),int8( 0));
    
%     disp(strcat('start euclid for  ',foldernames{i}));
%     run_ptb_function(videonameEuclid,int8(4),int8( 1),int8( 0));  
%     
end