function RawData = LoadData()
%clear all;
    basepath = "F:\ExperimentalRawData\DataProcessing\";

    path(1) = basepath+"20201206_[0,1,2,4,8,16uM]CellobioseInhibition_Good\";
    path(2) = basepath+"20210117_[0,0.5,1,2,4,8,16uM]CellobioseInhibition_Good\";
    folderNums =size(path,2);


    ConcentrationList = ["Control";"0.5mM";"1mM";"2mM";"4mM";"8mM";"16mM"];
    NConList = size(ConcentrationList,1);

    RawData =  cell(NConList,1);

    for folderId = 1:folderNums
        fileList= dir(path(folderId));
        Nfiles = size(fileList,1);
        for i = 1:Nfiles
            name = string(fileList(i).name);
            for conId = 1:NConList
                if contains(name,ConcentrationList(conId)) && ~contains(name,"Metadata")
                    file=load(path{folderId}+name);
                    RawData{conId}.Molecule{folderId} = file.Molecule;
                end
                if contains(name,ConcentrationList(conId)) && contains(name,"Metadata")
                     file=load(path{folderId}+name);
                     RawData{conId}.Metadata{folderId} = file.formatedData.metadata;
                     RawData{conId}.Config{folderId} = file.formatedData.Config;
                end
            end
        end
    end%folder id

