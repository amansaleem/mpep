function animalName = animalNameSelector(parentFig, currentName)
animalName = [];
f = figure();
set(f, 'MenuBar', 'none', 'Name', 'Select animal', 'NumberTitle', 'off','Resize', 'off', ...
    'WindowStyle', 'modal');
w = 470;
h = 165;
parentPos = get(parentFig, 'Position');
newPos = [parentPos(1)+parentPos(3)/2-w/2, parentPos(2)+parentPos(4)/2-h/2, w, h];
set(f, 'Position', newPos);



AToZ = mat2cell(char(65:90)', ones(26, 1));
buttonGroup = uibuttongroup('visible','on', 'Parent', f);

u1 = uicontrol('Style','Radio','String','New animal:',...
    'pos',[10 h-5-25 150 25],'parent',buttonGroup);
u2 = uicontrol('Style','Radio','String','Existing animal:',...
    'pos',[10 h-65-25 150 25],'parent',buttonGroup);

selectu1 = @(src,evt)(set(buttonGroup,'SelectedObject',u1));
selectu2 = @(src,evt)(set(buttonGroup,'SelectedObject',u2));

uicontrol('Style', 'text', 'String', 'Animal type:', 'Position', [20 h-40-25 90 25]);
animalTypeBox = uicontrol('Style', 'popupmenu', 'Parent', f, 'Position', [105 h-35-25 35 25],...
    'String', AToZ, 'Callback', selectu1, 'Value', 13 , 'Background', [1 1 1]);
uicontrol('Style', 'text', 'String', 'Date (YYMMDD)', 'Position', [150 h-40-35 90 35]);
dateBox= uicontrol('Style', 'edit', 'Parent', f, 'Position', [245 h-35-25 60 25],...
    'Background', [1 1 1],'Callback', selectu1);
uicontrol('Style', 'text', 'String', 'Tag:', 'Position', [310 h-40-25 30 25]);
tagBox = uicontrol('Style', 'popupmenu', 'Parent', f, 'Position',[340 h-35-25 35 25], ...
    'String', [' '; AToZ], 'Callback', selectu1, 'Background', [1 1 1]);
customBox = uicontrol('Style', 'edit', 'Parent', f, 'Position',[380 h-35-25 70 25], 'Background', [1 1 1]);
existing = uicontrol('Style', 'edit', 'Parent', f , 'Position', [20 h-95-25 180 25],...
    'Background', [1 1 1], 'Callback', selectu2);

uicontrol('Style', 'pushbutton', 'String', 'Cancel', 'Position', [10 h-135-25 (w-20)/2 25], 'Callback',  @(src,evt)delete(f));
uicontrol('Style', 'pushbutton', 'String', 'OK', 'Position', [10+(w-20)/2 h-135-25 (w-20)/2 25],'Callback', @ok);

if nargin == 1 || isempty(currentName)
    set(buttonGroup,'SelectedObject',u1);
else
    set(buttonGroup,'SelectedObject',u2);
    set(existing, 'String', currentName);
end

uiwait();

    function ok(~,~)       
        if get(buttonGroup, 'SelectedObject') == u2
            animalName = upper(strtrim(get(existing, 'String')));
            
            dirs = Paths();
            dataDir = dirs.data;
            % create animal dir if it does not exist
            if ~exist(fullfile(dataDir, animalName), 'dir');
                animalName = [];
                msgbox('Animal does not exist!', 'Error');
                return;
            end
        else
            % check inputs correct format
            % combine
            % return
            date = get(dateBox, 'String');
            % check the string is a resonable date by converting it to date
            % then back to string and comparing
            dateValid = strcmp(datestr(datevec(date, 'yymmdd'), 'yymmdd'), date);    
            if ~dateValid
                msgbox('Please enter a valid date in the correct format (YYMMDD)', 'Error');
                return;
            end
            
            customStr = get(customBox, 'String');
            % custom string must be alphanumeric or '_'s
            customValid = length(customStr) >= 2 && length(customStr) <= 8 &&...
                isempty(find(customStr(~isstrprop(customStr, 'alphanum')) ~= '_', 1));
            
            if ~customValid
                msgbox(['Please enter a string consisting of letters, numbers, and underscores'...
                ' which is between 2 and 8 characters long.' ], 'Error');
                return;
            end
            
            animalType = AToZ{get(animalTypeBox, 'Value')};
            
            if get(tagBox, 'Value') == 1
               tag = ''; 
            else
               tag = AToZ{get(tagBox, 'Value')-1};
            end        
            
            animalName = upper([animalType date tag '_' customStr]);
        end
        delete(f)
    end

end