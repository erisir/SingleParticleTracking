a = formatedSaveDataFormat.metadata;
b = 1;
for i = 1:size(a,2)
     a(i).SetCatalog
    if a(i).SetCatalog == "All"
        b =b+1;
    end
end
b