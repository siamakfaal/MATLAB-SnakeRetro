% snake simulates the nostalgic game of snake. Just call or run the
% function and enjoy the game. The code may also be used to simulate
% planning algorithms or AI strategies.
%
% syntax
%   snake
%
%__________________________________________________________________________
% Copyright and disclaimer
% This software (snake.m) is provided by the provider (Siamak Faal) 
% "as is" and with all faults. The provider makes no representations or 
% warranties of any kind concerning the safety, suitability, lack of 
% viruses, inaccuracies, typographical errors, or other harmful components 
% of this software product. There are inherent dangers in the use of any 
% software, and you are solely responsible for determining whether this 
% software product is compatible with your application, equipment and other
% software installed on your equipment. You are also solely responsible for
% the protection of your equipment and backup of your data, and the 
% provider will not be liable for any damages you may suffer in connection 
% with using, modifying, or distributing this software product. 
% Additionally, all data, information and examples provided in this 
% document are for informational purposes only. 
% All information is provided on an as is basis and the author 
% (Siamak G. Faal) makes no representations as to accuracy, completeness, 
% correctness, suitability, or validity of any information provided. 
% The author will not be liable for any errors, omissions, or delays in 
% this information or any losses, injuries, or damages arising from its 
% use. Your use of any information and/or examples is entirely at your own 
% risk. Should the software/information/examples prove defective, you 
% assume the entire cost of all service, repair or correction.
%
% Author: Siamak Faal
%         siamak.faal@gmail.com
%
% Version: 1.0
% Edit date: December 5, 2018
%   Revision history:
%       1.0: Initial release
%__________________________________________________________________________

function snake

global direction gamerun

worldSize = 21;
pauseTime = 0.1;
colors = [0.4 0.9 0.55; 0 0 0];
k = round(worldSize/2);

world = zeros(worldSize);
snakebody = [k*ones(1,6) ; k-5:k];
world(snakebody(1,:),snakebody(2,:)) = 1;

f = figure('KeyPressFcn',@getKey); colormap(f,colors);
ax = axes('Parent',f); hold(ax,'on');
display = imagesc(world,'Parent',ax);
axis(ax,'equal'); axis(ax,'tight'); axis(ax,'off');
title(ax,'Press Esc to exit','FontSize',15);
scoreBoard = annotation('textbox','String',{'Score = 0','Time = 0'},...
            'FontSize',12,'FontName','Monospaced',...
            'Position',[0.01 0.1 0.22 0.15],'BackgroundColor',[1 1 1],...
            'FaceAlpha',0.5,...
            'HorizontalAlignment','left','VerticalAlignment','middle');


food = randi([2 worldSize-1],2,1);
score = 0;
direction = [0;1];
gamerun = 1;

tic;
while(1)
    newLoc = mod(snakebody(:,end) + direction ,worldSize+1);
    newLoc(newLoc == 0) = worldSize*(sum(direction)==-1) +...
        (sum(direction)==1);
    world(snakebody(1,1),snakebody(2,1)) = 0;    
    for i=1:length(snakebody)-1
        snakebody(:,i) = snakebody(:,i+1);
        if(snakebody(:,i+1) == newLoc)
            gamerun = 0;
        end
    end
    
    if( newLoc == food )
        score = score + 1;
        if(mod(score,10)==1)
            pauseTime = max(pauseTime - 0.01, 0.02);
        end
        [food(1),food(2)] = ind2sub(size(world),...
            datasample(find(world==0),1));
        snakebody(:,end+1) = newLoc; %#ok<AGROW>
    else
        snakebody(:,end) = newLoc;
    end
    
    world(snakebody(1,end),snakebody(2,end)) = 1;
    world(food(1),food(2)) = 1;
    
    if(gamerun)
        set(display,'CData',world);
        t = toc;
        set(scoreBoard,'String',{sprintf('Score = %d',score),...
            sprintf('Time = %.1f',t)});
        pause(pauseTime);
    else
        annotation('textbox','String','Game Over!','FontSize',30,...
            'Position',[0.25 0.45 0.5 0.1],'BackgroundColor',[1 1 1],...
            'FaceAlpha',0.5,'FontName','Monospaced',...
            'HorizontalAlignment','center','VerticalAlignment','middle');
        return
    end
end
end

function getKey(~, eventdata)
global direction gamerun
switch(eventdata.Key)
    case 'leftarrow'
        if(direction(1)); direction = [ 0;-1]; end
    case 'rightarrow'
        if(direction(1)); direction = [ 0; 1]; end
    case 'uparrow'
        if(direction(2)); direction = [ 1; 0]; end
    case 'downarrow'
        if(direction(2)); direction = [-1; 0]; end
    case 'escape'
        gamerun = 0;
end
end