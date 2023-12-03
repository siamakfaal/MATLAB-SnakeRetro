% snake simulates the nostalgic game of snake. Just call or run the
% function and enjoy the game. The code may also be used to simulate
% planning algorithms or AI strategies.
%
%__________________________________________________________________________
% Copyright and disclaimer
% This software (snake.m) is provided by the provider (Siamak Faal)
% "as is" and with all faults. The provider makes no representations or
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
% All information is provided on an as is basis and the author
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
%__________________________________________________________________________


classdef snake < handle
    properties(Access=private)
        world_size = 21;
        init_update_rate = 10;
        max_update_rate = 100;
        colors = [0.4 0.9 0.55; 0 0 0];
    end

    properties(Access=private)
        world = [];
        body = [];
        dir = [0;1];
        gamerun = 1;
    end

    properties(Access=private)
        screen = [];
        scoreBoard = [];
    end


    methods(Access=public)
        function obj = snake()
            world_center = round(obj.world_size/2);
            obj.world = zeros(obj.world_size);
            obj.body = [world_center*ones(1,6) ; world_center-5:world_center];
            obj.world(obj.body(1,:), obj.body(2,:)) = 1;

            obj.build_figure()

            obj.play()
        end
    end

    methods(Access=private)
        function score = play(obj)
            food = randi([2 obj.world_size-1],2,1);
            score = 0;

            pause_time = 1/obj.init_update_rate;
            min_pause_time = 1/obj.max_update_rate;

            tic;
            while(1)
                head = mod(obj.body(:,end) + obj.dir , obj.world_size+1);
                head(head == 0) = obj.world_size*(sum(obj.dir)==-1) +...
                    (sum(obj.dir)==1);

                obj.world(obj.body(1,1),obj.body(2,1)) = 0;

                for i=1:length(obj.body)-1
                    obj.body(:,i) = obj.body(:,i+1);
                    if(obj.body(:,i+1) == head)
                        obj.gamerun = 0;
                    end
                end

                if( head == food )
                    score = score + 1;
                    if(mod(score,10)==1)
                        pause_time = max(pause_time - 0.01, min_pause_time);
                    end
                    empty_rooms = find(obj.world==0);
                    random_loc = randi([1, length(empty_rooms)],1);
                    [food(1),food(2)] = ind2sub(size(obj.world), random_loc);
                    obj.body(:,end+1) = head;
                else
                    obj.body(:,end) = head;
                end

                obj.world(obj.body(1,end), obj.body(2,end)) = 1;
                obj.world(food(1),food(2)) = 1;

                if(obj.gamerun)
                    set(obj.screen,'CData',obj.world);
                    t = toc;
                    set(obj.scoreBoard,'String',{sprintf('Score = %d',score),...
                        sprintf('Time = %.1f',t)});
                    pause(pause_time);
                else
                    annotation('textbox','String','Game Over!','FontSize',30,...
                        'Position',[0.25 0.45 0.5 0.1],'BackgroundColor',[1 1 1],...
                        'FaceAlpha',0.5,'FontName','Monospaced',...
                        'HorizontalAlignment','center','VerticalAlignment','middle');
                    return
                end
            end
        end

        function build_figure(obj)
            fig = figure('KeyPressFcn',@(x, eventdata)obj.read_keyboard(x, eventdata));
            colormap(fig, obj.colors);
            ax = axes(Parent=fig, NextPlot="add", DataAspectRatio=[1, 1, 1]);
            obj.screen = imagesc(obj.world,'Parent',ax);
            axis(ax,'equal'); axis(ax,'tight'); axis(ax,'off');
            title(ax,'Press Esc to exit','FontSize',15);
            obj.scoreBoard = annotation('textbox','String',{'Score = 0','Time = 0'},...
                'FontSize',12,'FontName','Monospaced',...
                'Position',[0.01 0.1 0.22 0.15],'BackgroundColor',[1 1 1],...
                'FaceAlpha',0.5,...
                'HorizontalAlignment','left','VerticalAlignment','middle');
        end

        function read_keyboard(obj, ~, eventdata)
            switch(eventdata.Key)
                case 'leftarrow'
                    if(obj.dir(1)); obj.dir = [ 0;-1]; end
                case 'rightarrow'
                    if(obj.dir(1)); obj.dir = [ 0; 1]; end
                case 'uparrow'
                    if(obj.dir(2)); obj.dir = [ 1; 0]; end
                case 'downarrow'
                    if(obj.dir(2)); obj.dir = [-1; 0]; end
                case 'escape'
                    obj.gamerun = 0;
            end
        end
    end

end
