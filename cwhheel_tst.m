P=[1	5.9688	10.406	18	23.969	31	39.656	48.531	57.094	66.344	75.969	86	93.938	104.91	113.78	125.56	132.53
];
sctravel=[1.6094	2.043	2.5039	3.0586	3.457	3.957	4.543	5.0781	5.5547	6.0469	6.5234	7.043	7.4883	8.0195	8.4922	9.1328	9.4219
];
 V=sctravel*(387.6/1000); %需液量
 
% V=[0.259765	0.7207	1.060546	1.5898	1.960937	2.4	2.6768	3	3.1	3.2	3.3 3.4 3.5
%  ];

%选择前后轴 'FA / RA / FA_RA'
xlab='FA';




%% 后续内容为计算过程 勿动！
%PV_Curve x轴参数
xlab_FA=[1,2,3,5,8,12,20,30,45,55,70,85,100,130];
xlab_RA=[0.64,1.875,9.828,22.6,33.422,52.53,74.4,85.062,102.7,142,143,144,145,146];
xlab_FA_RA=[1.25 2.5 5 10 20 50 100 150];




[xData, yData] = prepareCurveData( P, V );

    
% Set up fittype and options.
ft = fittype( app.DropDown.Value, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
k=1
switch (k)
    case 1
opts.StartPoint = [0.654079098476782 0.689214503140008 0.748151592823709];
case 2
    opts.StartPoint = [0.654079098476782 0.689214503140008 0.748151592823709 0.7];
    case 3
opts.StartPoint = [0.654079098476782 0.689214503140008 0.748151592823709 0.7 0.1 0.1 0.1];
case 4
    opts.StartPoint = [0.654079098476782 0.689214503140008 0.748151592823709 0.7 0.1 0.1];
end

% Fit model to data.
a= fit( xData, yData, ft, opts );

syms  x  
switch (k)
    case 1
y=a.A*x^0.25 + a.B*x^0.5 +a.C*x;
case 2
   y=a.A*x^0.25 + a.B*x^0.5 +a.C*x+a.D;
     case 3
y=a.A*(a.B*x+a.C)^(a.D*x+a.E)+a.F*x+a.G
case 4
   y=a.A*(a.B*x+a.C)^(a.D*x+a.E)+a.F*x
end


dz=diff(y,x);
yins=symfun(y,x);%算得PV曲线函数
fins=symfun(dz,x);%算得导数函数

if xlab=='FA'
    axle=xlab_FA;
elseif xlab=='RA'
axle=xlab_RA;

% else xlab=='FA_RA' %数组个数不统一 注释
% axle=xlab_FA_RA;
end
dy=eval (yins(axle));%根据PV曲线函数 取得不同压力下对应的 需液量


da=eval (fins(100));%根据导数函数    算出 100bar下对应的  斜率值  即a值 y=ax+b

kv=eval(yins(100));  % 100bar下的   需液量  即y值  y=ax+b 
Elas100=kv-da*100;%100bar下 对应的Elas100 的值 即b值 y=ax+b 
 class(dy./ eval(yins(100)))
app.c_pvEditField.Value=100/Elas100;
app.PV_CurveEditField.Value=[ '[',num2str( dy./ eval(yins(100))), ']'];%将100bar做为基准 算出value数组

h = plot(  xData, yData ,'-.*',axle,dy);
legend( h, 'V vs. P', '输出曲线', 'Location', 'southeast', 'Interpreter', 'none' );

xlabel( app.UIAxes, 'P', 'Interpreter', 'none' );
ylabel(app.UIAxes, 'V', 'Interpreter', 'none' );