%%
%% Copyright Peter Dimitrov 2018, All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%

%% * 2018-01-29
%%   Based on https://sourceforge.net/projects/cbsg/ (r196)
%%
-module(cbsg).

-export([financial_report/0,
	 sentence/0,
	 sentences/1,
	 short_workshop/0,
	 workshop/0]).


%%%=========================================================================
%%%  API
%%%=========================================================================

sentence() ->
    <<F,Rest/binary>> = articulated_propositions(),
    U = string:to_upper(F),
    <<U,Rest/binary,".">>.


sentences(N) ->
    sentences(N, <<>>).
%%
sentences(0, Acc) ->
    Acc;
sentences(N, Acc) ->
    S = sentence(),
    case Acc of
	<<>> -> % First sentence
	    sentences(N - 1, <<Acc/binary,S/binary>>);
	_ ->
	    sentences(N - 1, <<Acc/binary," ",S/binary>>)
    end.


financial_report() ->
    sentences(round(rand:normal(10,5)) + 5).


short_workshop() ->
    sentences(30).


workshop() ->
    sentences(500).


%%%=========================================================================
%%%  Persons or groups
%%%=========================================================================

boss() ->
    R2 = rand:uniform(2),
    case R2 of
	1 ->   % A fully normal boss (eventually, a managing one)
	    Managing = managing(),
	    Age = age(),
	    Exec = exec(),
	    Title = title(),
	    Department = department(),
	    <<Managing/binary,Age/binary,Exec/binary,Title/binary," of ",
	      Department/binary>>;
	_ ->   % Chief X Officer
	    Groupal = groupal(),
	    Department_or_Top_Role = department_or_top_role(),
	    Officer_or_Catalyst = officer_or_catalyst(),
	    Abbr = abbreviate(<<"Chief ",Department_or_Top_Role/binary," ",
		     Officer_or_Catalyst/binary>>, 0.6),
	    <<Groupal/binary,Abbr/binary>>
    end.


managing() ->
    managing(rand:uniform(8)).
%%
managing(1) -> <<"Managing ">>;   % The others only pretend to manage
managing(2) -> <<"Acting ">>;     % Well, then we could have an actor too
managing(3) -> <<"General ">>;
managing(_) -> <<"">>.


vice() ->
    vice(rand:uniform(40)).
%%
vice(R40)
  when 1 =< R40, R40 >= 10 -> <<"Vice ">>;
vice(11)                  -> <<"Corporate Vice ">>;
vice(_)                   -> <<"">>.


co() ->
    co(rand:uniform(8)).
%%
co(1) -> <<"Co-">>;
co(_) -> <<"">>.



title() ->
    title(rand:uniform(6), vice(), co()).
%%
title(1, Vice, Co) ->
    <<Vice/binary,Co/binary,"Director">>;
title(2, _Vice, Co) ->
    <<Co/binary,"Chief">>;
title(3, _Vice, Co) ->
    <<Co/binary,"Head">>;
title(4, Vice, Co) ->
    <<Vice/binary,Co/binary,"President">>;
title(5, _Vice, _Co) ->
    <<"Supervisor">>;
title(6, _Vice, Co) ->
    <<Co/binary,"Manager">>.



age() ->
    age(rand:uniform(4)).
%%
age(1) -> <<"Senior ">>;
age(_) -> <<"">>.


exec() ->
    exec(rand:uniform(12)).
%%
exec(1)    -> <<"Executive ">>;
exec(2)    -> <<"Principal ">>;
exec(_) -> <<"">>.


groupal() ->
    groupal(rand:uniform(20)).
%%
groupal(1)    -> <<"Group ">>;
groupal(2)    -> <<"Global ">>;
groupal(_) -> <<"">>.


department() ->
    department(rand:uniform(39)).
%%
department(1)  -> <<"Human Resources">>;
department(2)  -> <<"Controlling">>;
department(3)  -> <<"Internal Audit">>;
department(4)  -> <<"Legal">>;
department(5)  -> <<"Operations">>;
department(6)  -> <<"Management Office">>;
department(7)  -> <<"Customer Relations">>;
department(8)  -> <<"Client Leadership">>;
department(9)  -> <<"Client Relationship">>;
department(10) -> <<"Business Planning">>;
department(11) -> <<"Business Operations">>;
department(12) -> <<"IT Strategy">>;
department(13) -> <<"IT Operations">>;
department(14) -> <<"Marketing">>;
department(15) -> <<"Strategic Planning">>;
department(16) -> <<"Facilities Management">>;
department(17) -> <<"Innovation">>;
department(18) -> <<"Identity">>;
department(19) -> <<"Branding">>;
department(20) -> <<"Diversity and Inclusion">>;
department(21) -> <<"Media Relations">>;
department(22) -> <<"Value Added Services">>;
department(23) -> <<"Technology">>;
department(24) -> <<"Campaigning">>;
department(25) -> <<"Digital Marketing">>;
department(26) -> <<"Digital Transformation Office">>;
department(27) -> <<"Communications">>;
department(28) -> <<"Architecture">>;
department(29) -> <<"Data & Analytics">>;
department(30) -> <<"Compliance">>;
department(31) -> <<"Research & Development">>;
department(32) -> <<"Networking Enhancement">>;
department(33) -> <<"Innovative Strategies">>;
department(34) -> <<"Global Innovation Insight">>;
department(35) -> <<"Transition Transformation">>;
department(36) -> <<"Change Management">>;
department(37) -> <<"Global Strategy">>;
department(38) -> <<"Creativity and Innovation">>;
department(39) -> <<"Information Security">>.


department_or_top_role() ->
    department_or_top_role(rand:uniform(52)).
department_or_top_role(1)  -> <<"Visionary">>;
department_or_top_role(2)  -> <<"Digital">>;
department_or_top_role(3)  -> <<"Technical">>;
department_or_top_role(4)  -> <<"Manifesto">>;
department_or_top_role(5)  -> <<"Operating">>;
department_or_top_role(6)  -> <<"Product">>;
department_or_top_role(7)  -> <<"Scheme">>;
department_or_top_role(8)  -> <<"Growth">>;
department_or_top_role(9)  -> <<"Brand">>;
department_or_top_role(10) -> <<"Sales">>;
department_or_top_role(11) -> <<"Networking">>;
department_or_top_role(12) -> <<"Content">>;
department_or_top_role(13) -> <<"Holacracy">>;
department_or_top_role(_) ->
    department().


officer_or_catalyst() ->
    officer_or_catalyst(rand:uniform(20)).
officer_or_catalyst(1) -> <<"Catalyst">>;
officer_or_catalyst(2) -> <<"Futurist">>;
officer_or_catalyst(3) -> <<"Strategist">>;
officer_or_catalyst(4) -> <<"Technologist">>;
officer_or_catalyst(_) -> <<"Officer">>.


abbreviate(Long, Probability) ->
    case (rand:uniform() < Probability) of
	true ->
	    Short = silly_abbreviation_generator_sag(Long),
	    <<Long/binary," (",Short/binary,")">>;
	false ->
	    Long
    end.


silly_abbreviation_generator_sag(X) ->
    silly_abbreviation_generator_sag(X, <<>>).
%%
silly_abbreviation_generator_sag(<<>>, Acc) ->
    Acc;
silly_abbreviation_generator_sag(<<$ ,T/binary>>, Acc) ->
    silly_abbreviation_generator_sag(T, Acc);
silly_abbreviation_generator_sag(<<$&,T/binary>>, Acc) ->
    silly_abbreviation_generator_sag(T, Acc);
silly_abbreviation_generator_sag(<<H,_/binary>> = X, Acc) ->
    case binary:match(X, <<" ">>) of
	{Pos, _} ->
	    {_, T} = split_binary(X, Pos + 1),
	    silly_abbreviation_generator_sag(T, <<Acc/binary,H>>);
	nomatch ->
	    <<Acc/binary,H>>
    end.


person(false) ->
    person_singular(rand:uniform(45));
person(true) ->
    person_plural(rand:uniform(33)).
%%
person_singular(1)  -> <<"steering committee">>;
person_singular(2)  -> <<"group">>;
person_singular(3)  -> <<"project manager">>;
person_singular(4)  ->
    Person = thing_atom(random_plural()),
    <<Person/binary," champion">>;
person_singular(5)  -> <<"community">>;
person_singular(6)  -> <<"sales manager">>;
person_singular(7)  -> <<"enabler">>;
person_singular(8)  -> <<"powerful champion">>;
person_singular(9)  -> <<"thought leader">>;
person_singular(10) -> <<"gatekeeper">>;
person_singular(11) -> <<"resource">>;   % no, we're not people, we're "resources"
person_singular(12) -> <<"senior support staff">>;
person_singular(13) -> <<"brand manager">>;
person_singular(14) -> <<"category manager">>;
person_singular(15) -> <<"account executive">>;
person_singular(16) -> <<"project leader">>;
person_singular(17) -> <<"product manager">>;
person_singular(18) -> <<"naming committee">>;
person_singular(19) -> <<"executive committee">>;
person_singular(20) -> <<"white-collar workforce">>;
person_singular(21) -> <<"innovator">>;
person_singular(22) -> <<"game changer">>;
person_singular(23) -> <<"visionary">>;
person_singular(24) -> <<"market thinker">>;
person_singular(25) -> <<"network">>;
person_singular(26) -> <<"initiator">>;
person_singular(27) -> <<"change agent">>;
person_singular(28) -> <<"rockstar">>;
person_singular(29) -> <<"facilitator">>;
person_singular(30) -> <<"disruptor">>;
person_singular(31) -> <<"challenger">>;
person_singular(_) -> boss().   % ~ 1/3
%%
person_plural(1)  -> <<"key people">>;
person_plural(2)  -> <<"human resources">>;
person_plural(3)  -> <<"customers">>;
person_plural(4)  -> <<"clients">>;
person_plural(5)  -> <<"resources">>;
person_plural(6)  -> <<"team players">>;
person_plural(7)  -> <<"enablers">>;
person_plural(8)  -> <<"stakeholders">>;
person_plural(9)  -> <<"standard-setters">>;
person_plural(10) -> <<"partners">>;
person_plural(11) -> <<"business leaders">>;
person_plural(12) -> <<"thinkers/planners">>;
person_plural(13) -> <<"white-collar workers">>;
person_plural(14) -> <<"board-level executives">>;
person_plural(15) -> <<"key representatives">>;
person_plural(16) -> <<"innovators">>;
person_plural(17) -> <<"policy makers">>;
person_plural(18) -> <<"pioneers">>;
person_plural(19) -> <<"game changers">>;
person_plural(20) -> <<"market thinkers">>;
person_plural(21) -> <<"thought leaders">>;
person_plural(22) -> <<"mediators">>;
person_plural(23) -> <<"facilitators">>;
person_plural(24) -> <<"attackers">>;
person_plural(25) -> <<"initiators">>;
person_plural(26) -> <<"decision makers">>;
person_plural(27) -> <<"Growth Hackers">>;
person_plural(28) -> <<"Digital Marketers">>;
person_plural(29) -> <<"Creative Technologists">>;
person_plural(30) -> <<"Product Managers">>;
person_plural(31) -> <<"Product Owners">>;
person_plural(32) -> <<"disruptors">>;
person_plural(33) -> <<"challengers">>.


matrix_or_so() ->
    matrix_or_so(rand:uniform(12)).
%%
matrix_or_so(R12) when R12 =:= 1; R12 =:= 2 ->
    <<"organization">>;   % a bit flat, but flashy combined with "within the "
matrix_or_so(R12) when 3 =< R12, R12 =< 6 ->
    <<"silo">>;           % classic 1-dimension units in organizations
matrix_or_so(R12) when 7 =< R12, R12 =< 10 ->
    <<"matrix">>;         % 2nd dimension, with dotted lines
matrix_or_so(11) ->
    <<"cube">>;           % 3rd dimension (Converium); at last then, the company has become totally dysfunctional
matrix_or_so(12) ->
    <<"sphere">>.         % another esoteric 3-dimensional structure - GM 20-Jun-2011


%%%=========================================================================
%%%  Things
%%%=========================================================================

thing_adjective() ->
    thing_adjective(rand:uniform(437)).
%%
thing_adjective(1)   -> <<"efficient">>;
thing_adjective(2)   -> <<"strategic">>;
thing_adjective(3)   -> <<"constructive">>;
thing_adjective(4)   -> <<"proactive">>;
thing_adjective(5)   -> <<"strong">>;
thing_adjective(6)   -> <<"key">>;
thing_adjective(7)   -> <<"global">>;
thing_adjective(8)   -> <<"corporate">>;
thing_adjective(9)   -> <<"cost-effective">>;
thing_adjective(10)  -> <<"focused">>;

thing_adjective(11)  -> <<"top-line">>;
thing_adjective(12)  -> <<"credible">>;
thing_adjective(13)  -> <<"agile">>;
thing_adjective(14)  -> <<"holistic">>;
thing_adjective(15)  -> <<"new">>;
thing_adjective(16)  -> <<"adaptive">>;
thing_adjective(17)  -> <<"optimal">>;
thing_adjective(18)  -> <<"unique">>;
thing_adjective(19)  -> <<"core">>;

thing_adjective(20)  -> <<"compliant">>;
thing_adjective(21)  -> <<"goal-oriented">>;
thing_adjective(22)  -> <<"non-linear">>;
thing_adjective(23)  -> <<"problem-solving">>;
thing_adjective(24)  -> <<"prioritizing">>;
thing_adjective(25)  -> <<"cultural">>;
thing_adjective(26)  -> <<"future-oriented">>;
thing_adjective(27)  -> <<"potential">>;
thing_adjective(28)  -> <<"versatile">>;
thing_adjective(29)  -> <<"leading">>;

thing_adjective(30)  -> <<"dynamic">>;
thing_adjective(31)  -> <<"progressive">>;
thing_adjective(32)  -> <<"non-deterministic">>;
thing_adjective(33)  -> <<"informed">>;
thing_adjective(34)  -> <<"leveraged">>;
thing_adjective(35)  -> <<"challenging">>;
thing_adjective(36)  -> <<"intelligent">>;
thing_adjective(37)  -> <<"controlled">>;
thing_adjective(38)  -> <<"educated">>;
thing_adjective(39)  -> <<"non-standard">>;

thing_adjective(40)  -> <<"underlying">>;
thing_adjective(41)  -> <<"centralized">>;
thing_adjective(42)  -> <<"decentralized">>;
thing_adjective(43)  -> <<"reliable">>;
thing_adjective(44)  -> <<"consistent">>;
thing_adjective(45)  -> <<"competent">>;
thing_adjective(46)  -> <<"prospective">>;
thing_adjective(47)  -> <<"collateral">>;
thing_adjective(48)  -> <<"functional">>;
thing_adjective(49)  -> <<"tolerably expensive">>;

thing_adjective(50)  -> <<"organic">>;
thing_adjective(51)  -> <<"forward-looking">>;
thing_adjective(52)  -> <<"next-level">>;
thing_adjective(53)  -> <<"executive">>;
thing_adjective(54)  -> <<"seamless">>;
thing_adjective(55)  -> <<"spectral">>;
thing_adjective(56)  -> <<"balanced">>;
thing_adjective(57)  -> <<"effective">>;
thing_adjective(58)  -> <<"integrated">>;
thing_adjective(59)  -> <<"systematized">>;

thing_adjective(60)  -> <<"parallel">>;
thing_adjective(61)  -> <<"responsive">>;
thing_adjective(62)  -> <<"synchronized">>;
thing_adjective(63)  -> <<"carefully-designed">>;
thing_adjective(64)  -> <<"carefully thought-out">>;
thing_adjective(65)  -> <<"cascading">>;
thing_adjective(66)  -> <<"high-level">>;
thing_adjective(67)  -> <<"siloed">>;
thing_adjective(68)  -> <<"operational">>;
thing_adjective(69)  -> <<"future-ready">>;

thing_adjective(70)  -> <<"flexible">>;
thing_adjective(71)  -> <<"movable">>;
thing_adjective(72)  -> <<"right">>;
thing_adjective(73)  -> <<"productive">>;
thing_adjective(74)  -> <<"evolutionary">>;
thing_adjective(75)  -> <<"overarching">>;
thing_adjective(76)  -> <<"documented">>;
thing_adjective(77)  -> <<"awesome">>;
thing_adjective(78)  -> <<"coordinated">>;
thing_adjective(79)  -> <<"aligned">>;

thing_adjective(80)  -> <<"enhanced">>;
thing_adjective(81)  -> <<"control-based">>;
thing_adjective(82)  -> <<"industry-standard">>;
thing_adjective(83)  -> <<"accepted">>;
thing_adjective(84)  -> <<"agreed-upon">>;
thing_adjective(85)  -> <<"target">>;
thing_adjective(86)  -> <<"customer-centric">>;
thing_adjective(87)  -> <<"wide-spectrum">>;
thing_adjective(88)  -> <<"well-communicated">>;
thing_adjective(89)  -> <<"cutting-edge">>;

thing_adjective(90)  -> <<"state-of-the-art">>;
thing_adjective(91)  -> <<"verifiable">>;
thing_adjective(92)  -> <<"six-sigma">>;
thing_adjective(93)  -> <<"solid">>;
thing_adjective(94)  -> <<"inspiring">>;
thing_adjective(95)  -> <<"growing">>;
thing_adjective(96)  -> <<"market-altering">>;
thing_adjective(97)  -> <<"vertical">>;
thing_adjective(98)  -> <<"emerging">>;
thing_adjective(99)  -> <<"differentiating">>;

thing_adjective(100) -> <<"integrative">>;
thing_adjective(101) -> <<"cross-functional">>;
thing_adjective(102) -> <<"measurable">>;
thing_adjective(103) -> <<"well-planned">>;
thing_adjective(104) -> <<"accessible">>;
thing_adjective(105) -> <<"actionable">>;
thing_adjective(106) -> <<"accurate">>;
thing_adjective(107) -> <<"insightful">>;
thing_adjective(108) -> <<"relevant">>;
thing_adjective(109) -> <<"long-term">>;

thing_adjective(110) -> <<"longer-term">>;
thing_adjective(111) -> <<"tactical">>;
thing_adjective(112) -> <<"best-of-breed">>;
thing_adjective(113) -> <<"robust">>;
thing_adjective(114) -> <<"targeted">>;
thing_adjective(115) -> <<"personalized">>;
thing_adjective(116) -> <<"interactive">>;
thing_adjective(117) -> <<"streamlined">>;
thing_adjective(118) -> <<"transparent">>;
thing_adjective(119) -> <<"traceable">>;

thing_adjective(120) -> <<"far-reaching">>;
thing_adjective(121) -> <<"powerful">>;
thing_adjective(122) -> <<"improved">>;
thing_adjective(123) -> <<"executive-level">>;
thing_adjective(124) -> <<"goal-based">>;
thing_adjective(125) -> <<"top-level">>;
thing_adjective(126) -> <<"value-added">>;
thing_adjective(127) -> <<"value-adding">>;
thing_adjective(128) -> <<"streamlining">>;
thing_adjective(129) -> <<"time-honored">>;

thing_adjective(130) -> <<"idiosyncratic">>;
thing_adjective(131) -> <<"sustainable">>;
thing_adjective(132) -> <<"in-depth">>;
thing_adjective(133) -> <<"immersive">>;
thing_adjective(134) -> <<"cross-industry">>;
thing_adjective(135) -> <<"time-phased">>;
thing_adjective(136) -> <<"day-to-day">>;
thing_adjective(137) -> <<"present-day">>;
thing_adjective(138) -> <<"modern-day">>;
thing_adjective(139) -> <<"profit-maximizing">>;

thing_adjective(140) -> <<"generic">>;
thing_adjective(141) -> <<"granular">>;
thing_adjective(142) -> <<"values-based">>;
thing_adjective(143) -> <<"value-driven">>;
thing_adjective(144) -> <<"well-defined">>;
thing_adjective(145) -> <<"outward-looking">>;
thing_adjective(146) -> <<"scalable">>;
thing_adjective(147) -> <<"strategy-focused">>;
thing_adjective(148) -> <<"promising">>;
thing_adjective(149) -> <<"collaborative">>;

thing_adjective(150) -> <<"scenario-based">>;
thing_adjective(151) -> <<"principle-based">>;
thing_adjective(152) -> <<"vision-setting">>;
thing_adjective(153) -> <<"client-oriented">>;
thing_adjective(154) -> <<"long-established">>;
thing_adjective(155) -> <<"established">>;
thing_adjective(156) -> <<"organizational">>;
thing_adjective(157) -> <<"visionary">>;
thing_adjective(158) -> <<"trusted">>;
thing_adjective(159) -> <<"full-scale">>;

thing_adjective(160) -> <<"firm-wide">>;
thing_adjective(161) -> <<"fast-growth">>;
thing_adjective(162) -> <<"performance-based">>;
thing_adjective(163) -> <<"high-performing">>;
thing_adjective(164) -> <<"high-performance">>;
thing_adjective(165) -> <<"cross-enterprise">>;
thing_adjective(166) -> <<"outsourced">>;
thing_adjective(167) -> <<"situational">>;
thing_adjective(168) -> <<"bottom-up">>;
thing_adjective(169) -> <<"multidisciplinary">>;

thing_adjective(170) -> <<"one-to-one">>;
thing_adjective(171) -> <<"goal-directed">>;
thing_adjective(172) -> <<"intra-organisational">>;
thing_adjective(173) -> <<"data-inspired">>;
thing_adjective(174) -> <<"multi-source">>;
thing_adjective(175) -> <<"360-degree">>;
thing_adjective(176) -> <<"motivational">>;
thing_adjective(177) -> <<"differentiated">>;
thing_adjective(178) -> <<"solutions-based">>;
thing_adjective(179) -> <<"compelling">>;

thing_adjective(180) -> <<"structural">>;
thing_adjective(181) -> <<"go-to-market">>;
thing_adjective(182) -> <<"on-message">>;
thing_adjective(183) -> <<"productivity-enhancing">>;
thing_adjective(184) -> <<"value-enhancing">>;
thing_adjective(185) -> <<"mission-critical">>;
thing_adjective(186) -> <<"business-enabling">>;
thing_adjective(187) -> <<"transitional">>;
thing_adjective(188) -> <<"future">>;
thing_adjective(189) -> <<"game-changing">>;

thing_adjective(190) -> <<"enterprise-wide">>;
thing_adjective(191) -> <<"rock-solid">>;
thing_adjective(192) -> <<"bullet-proof">>;
thing_adjective(193) -> <<"superior">>;
thing_adjective(194) -> <<"genuine">>;
thing_adjective(195) -> <<"alert">>;
thing_adjective(196) -> <<"nimble">>;
thing_adjective(197) -> <<"phased">>;
thing_adjective(198) -> <<"selective">>;
thing_adjective(199) -> <<"macroscopic">>;

thing_adjective(200) -> <<"low-risk high-yield">>;
thing_adjective(201) -> <<"interconnected">>;
thing_adjective(202) -> <<"high-margin">>;
thing_adjective(203) -> <<"resilient">>;
thing_adjective(204) -> <<"high-definition">>;
thing_adjective(205) -> <<"well-crafted">>;
thing_adjective(206) -> <<"fine-grained">>;
thing_adjective(207) -> <<"context-aware">>;
thing_adjective(208) -> <<"multi-tasked">>;
thing_adjective(209) -> <<"feedback-based">>;

thing_adjective(210) -> <<"analytics-based">>;
thing_adjective(211) -> <<"fact-based">>;
thing_adjective(212) -> <<"usage-based">>;
thing_adjective(213) -> <<"multi-channel">>;
thing_adjective(214) -> <<"omni-channel">>;
thing_adjective(215) -> <<"cross-channel">>;
thing_adjective(216) -> <<"specific">>;
thing_adjective(217) -> <<"heart-of-the-business">>;
thing_adjective(218) -> <<"responsible">>;
thing_adjective(219) -> <<"socially conscious">>;

thing_adjective(220) -> <<"results-centric">>;
thing_adjective(221) -> <<"business-led">>;
thing_adjective(222) -> <<"well-positioned">>;
thing_adjective(223) -> <<"end-to-end">>;
thing_adjective(224) -> <<"high-quality">>;
thing_adjective(225) -> <<"siloed">>;
thing_adjective(226) -> <<"modular">>;
thing_adjective(227) -> <<"service-oriented">>;
thing_adjective(228) -> <<"competitive">>;
thing_adjective(229) -> <<"scale-as-you-grow">>;

thing_adjective(230) -> <<"outside-in">>;
thing_adjective(231) -> <<"hyper-hybrid">>;
thing_adjective(232) -> <<"long-running">>;
thing_adjective(233) -> <<"large-scale">>;
thing_adjective(234) -> <<"wide-ranging">>;
thing_adjective(235) -> <<"active">>;
thing_adjective(236) -> <<"stellar">>;
thing_adjective(237) -> <<"dramatic">>;
thing_adjective(238) -> <<"aggressive">>;
thing_adjective(239) -> <<"innovative">>;

thing_adjective(240) -> <<"high-powered">>;
thing_adjective(241) -> <<"above-average">>;
thing_adjective(242) -> <<"result-driven">>;
thing_adjective(243) -> <<"innovation-driven">>;
thing_adjective(244) -> <<"customized">>;
thing_adjective(245) -> <<"outstanding">>;
thing_adjective(246) -> <<"non-mainstream">>;
thing_adjective(247) -> <<"customer-facing">>;
thing_adjective(248) -> <<"consumer-facing">>;
thing_adjective(249) -> <<"unified">>;

thing_adjective(250) -> <<"cooperative">>;
thing_adjective(251) -> <<"laser-focused">>;
thing_adjective(252) -> <<"well-implemented">>;
thing_adjective(253) -> <<"diversifying">>;
thing_adjective(254) -> <<"market-changing">>;
thing_adjective(255) -> <<"metrics-driven">>;
thing_adjective(256) -> <<"pre-integrated">>;
thing_adjective(257) -> <<"solution-oriented">>;
thing_adjective(258) -> <<"impactful">>;
thing_adjective(259) -> <<"world-class">>;

thing_adjective(260) -> <<"front-end">>;
thing_adjective(261) -> <<"leading-edge">>;
thing_adjective(262) -> <<"cost-competitive">>;
thing_adjective(263) -> <<"extensible">>;
thing_adjective(264) -> <<"under-the-radar">>;
thing_adjective(265) -> <<"high-grade">>;
thing_adjective(266) -> <<"structured">>;
thing_adjective(267) -> <<"trust-based">>;
thing_adjective(268) -> <<"intra-company">>;
thing_adjective(269) -> <<"inter-company">>;

thing_adjective(270) -> <<"profit-oriented">>;
thing_adjective(271) -> <<"sizeable">>;
thing_adjective(272) -> <<"highly satisfactory">>;
thing_adjective(273) -> <<"bi-face">>;
thing_adjective(274) -> <<"tri-face">>;
thing_adjective(275) -> <<"disruptive">>;
thing_adjective(276) -> <<"technological">>;
thing_adjective(277) -> <<"marketplace">>;   % noun used as an adjectiv
thing_adjective(278) -> <<"fast-evolving">>;
thing_adjective(279) -> <<"open">>;

thing_adjective(280) -> <<"fully networked">>;
thing_adjective(281) -> <<"adoptable">>;
thing_adjective(282) -> <<"trustworthy">>;
thing_adjective(283) -> <<"science-based">>;
thing_adjective(284) -> <<"non-manufacturing">>;
thing_adjective(285) -> <<"multi-divisional">>;
thing_adjective(286) -> <<"controllable">>;
thing_adjective(287) -> <<"high-priority">>;
thing_adjective(288) -> <<"market-driven">>;
thing_adjective(289) -> <<"market-driving">>;

thing_adjective(290) -> <<"ingenious">>;
thing_adjective(291) -> <<"business-for-business">>;
thing_adjective(292) -> <<"inspirational">>;
thing_adjective(293) -> <<"winning">>;
thing_adjective(294) -> <<"boundaryless">>;
thing_adjective(295) -> <<"reality-based">>;
thing_adjective(296) -> <<"customer-focused">>;
thing_adjective(297) -> <<"preemptive">>;
thing_adjective(298) -> <<"location-specific">>;
thing_adjective(299) -> <<"revealing">>;

thing_adjective(300) -> <<"inventory-planning">>;
thing_adjective(301) -> <<"ubiquitous">>;
thing_adjective(302) -> <<"number-one">>;
thing_adjective(303) -> <<"results-oriented">>;
thing_adjective(304) -> <<"socially enabled">>;
thing_adjective(305) -> <<"well-scoped">>;
thing_adjective(306) -> <<"insight-based">>;
thing_adjective(307) -> <<"high-impact">>;
thing_adjective(308) -> <<"technology-driven">>;
thing_adjective(309) -> <<"knowledge-based">>;

thing_adjective(310) -> <<"information-age">>;
thing_adjective(311) -> <<"technology-centered">>;
thing_adjective(312) -> <<"critical">>;
thing_adjective(313) -> <<"cognitive">>;
thing_adjective(314) -> <<"acculturated">>;
thing_adjective(315) -> <<"client-centric">>;
thing_adjective(316) -> <<"comprehensive">>;
thing_adjective(317) -> <<"ground-breaking">>;
thing_adjective(318) -> <<"long-standing">>;
thing_adjective(319) -> <<"accelerating">>;

thing_adjective(320) -> <<"forward-thinking">>;
thing_adjective(321) -> <<"mind-blowing">>;
thing_adjective(322) -> <<"jaw-dropping">>;
thing_adjective(323) -> <<"transformative">>;
thing_adjective(324) -> <<"better-than-planned">>;
thing_adjective(325) -> <<"vital">>;
thing_adjective(326) -> <<"radical">>;
thing_adjective(327) -> <<"expanding">>;
thing_adjective(328) -> <<"fierce">>;
thing_adjective(329) -> <<"single-minded">>;

thing_adjective(330) -> <<"mindful">>;
thing_adjective(331) -> <<"top-down">>;
thing_adjective(332) -> <<"hands-on">>;
thing_adjective(333) -> <<"one-on-one">>;
thing_adjective(334) -> <<"analytic">>;
thing_adjective(335) -> <<"top">>;
thing_adjective(336) -> <<"elite">>;
thing_adjective(337) -> <<"dedicated">>;
thing_adjective(338) -> <<"curated">>;
thing_adjective(339) -> <<"highly-curated">>;

thing_adjective(340) -> <<"re-imagined">>;
thing_adjective(341) -> <<"thought-provoking">>;
thing_adjective(342) -> <<"quality-oriented">>;
thing_adjective(343) -> <<"task-oriented">>;
thing_adjective(344) -> <<"teamwork-oriented">>;
thing_adjective(345) -> <<"high-growth">>;
thing_adjective(346) -> <<"fast-track">>;
thing_adjective(347) -> <<"next-generation">>;
thing_adjective(348) -> <<"new-generation">>;
thing_adjective(349) -> <<"best-in-class">>;

thing_adjective(350) -> <<"best-of-class">>;
thing_adjective(351) -> <<"first-class">>;
thing_adjective(352) -> <<"top-class">>;
thing_adjective(353) -> <<"superior-quality">>;
thing_adjective(354) -> <<"synergistic">>;
thing_adjective(355) -> <<"micro-macro">>;
thing_adjective(356) -> <<"organization-wide">>;
thing_adjective(357) -> <<"clear-cut">>;
thing_adjective(358) -> <<"data-driven">>;
thing_adjective(359) -> <<"evidence-based">>;

thing_adjective(360) -> <<"transformational">>;
thing_adjective(361) -> <<"fast-paced">>;
thing_adjective(362) -> <<"real-time">>;
thing_adjective(363) -> <<"pre-approved">>;
thing_adjective(364) -> <<"unconventional">>;
thing_adjective(365) -> <<"advanced-analytics">>;
thing_adjective(366) -> <<"insight-driven">>;
thing_adjective(367) -> <<"sprint-based">>;
thing_adjective(368) -> <<"digitized">>;
thing_adjective(369) -> <<"hypothesis-driven">>;

thing_adjective(370) -> <<"governance-related">>;
thing_adjective(371) -> <<"convergent">>;
thing_adjective(372) -> <<"leadership-defined">>;
thing_adjective(373) -> <<"operations-oriented">>;
thing_adjective(374) -> <<"long-range">>;
thing_adjective(375) -> <<"dimensional">>;
thing_adjective(376) -> <<"award-winning">>;
thing_adjective(377) -> <<"user-centric">>;
thing_adjective(378) -> <<"first-to-market">>;
thing_adjective(379) -> <<"first-mover">>;

thing_adjective(380) -> <<"cross-platform">>;
thing_adjective(381) -> <<"on-the-go">>;
thing_adjective(382) -> <<"all-encompassing">>;
thing_adjective(383) -> <<"matrixed">>;
thing_adjective(384) -> <<"growth-enabling">>;
thing_adjective(385) -> <<"skills-based">>;
thing_adjective(386) -> <<"bottom-line">>;
thing_adjective(387) -> <<"top-shelf">>;
thing_adjective(388) -> <<"insourced">>;
thing_adjective(389) -> <<"out-of-the-box">>;

thing_adjective(390) -> <<"engaging">>;
thing_adjective(391) -> <<"on- and offline">>;
thing_adjective(392) -> <<"goals-based">>;
thing_adjective(393) -> <<"enriching">>;
thing_adjective(394) -> <<"medium-to-long-term">>;
thing_adjective(395) -> <<"adequate">>;
thing_adjective(396) -> <<"awareness-raising">>;
thing_adjective(397) -> <<"compatible">>;
thing_adjective(398) -> <<"supportive">>;
thing_adjective(399) -> <<"inspired">>;

thing_adjective(400) -> <<"high-return">>;
thing_adjective(401) -> <<"turn-key">>;
thing_adjective(402) -> <<"turnkey">>;
thing_adjective(403) -> <<"decision-ready">>;
thing_adjective(404) -> <<"diversified">>;
thing_adjective(405) -> <<"demanding">>;
thing_adjective(406) -> <<"ambitious">>;
thing_adjective(407) -> <<"domain-relevant">>;
thing_adjective(408) -> <<"novel">>;
thing_adjective(409) -> <<"pre-planned">>;

thing_adjective(410) -> <<"well-respected">>;
thing_adjective(411) -> <<"market-based">>;
thing_adjective(412) -> <<"distributor-based">>;
thing_adjective(413) -> <<"area-wide">>;
thing_adjective(414) -> <<"movements-based">>;
thing_adjective(415) -> <<"ever-changing">>;
thing_adjective(416) -> <<"purpose-driven">>;
thing_adjective(417) -> <<"resourceful">>;
thing_adjective(418) -> <<"real-life">>;
thing_adjective(419) -> <<"vibrant">>;

thing_adjective(420) -> <<"bright">>;
thing_adjective(421) -> <<"pure-play">>;
thing_adjective(422) -> <<"bespoke">>;
thing_adjective(423) -> <<"pivotal">>;
thing_adjective(424) -> <<"efficiency-enhancing">>;
thing_adjective(425) -> <<"multi-level">>;
thing_adjective(426) -> <<"rich">>;
thing_adjective(427) -> <<"frictionless">>;
thing_adjective(428) -> <<"up-to-the-minute">>;
thing_adjective(429) -> <<"sourced">>;

thing_adjective(430) -> <<"outcome-driven">>;
thing_adjective(431) -> <<"hyperaware">>;
thing_adjective(432) -> <<"high-velocity">>;
thing_adjective(433) -> <<"lean">>;
thing_adjective(434) -> <<"unmatched">>;
thing_adjective(435) -> <<"industry-leading">>;
thing_adjective(436) -> <<"multi-sided">>;
thing_adjective(437) -> <<"tailor-made">>.


timeless_event() ->
    timeless_event(rand:uniform(4)).
%%
timeless_event(1) -> <<"kick-off">>;
timeless_event(2) -> <<"roll-out">>;
timeless_event(3) -> <<"client event">>;
timeless_event(4) -> <<"quarter results">>.


growth() ->
    Superlative = superlative(),
    GrowthAtom = growth_atom(),
    <<Superlative/binary,$ ,GrowthAtom/binary>>.

growth_atom() ->
    growth_atom(rand:uniform(17)).
%%
growth_atom(1)  -> <<"growth">>;
growth_atom(2)  -> <<"improvement">>;
growth_atom(3)  -> <<"throughput increase">>;
growth_atom(4)  -> <<"efficiency gain">>;
growth_atom(5)  -> <<"yield enhancement">>;
growth_atom(6)  -> <<"expansion">>;
growth_atom(7)  -> <<"productivity improvement">>;
growth_atom(8)  -> <<"gain in task efficiency">>;
growth_atom(9)  -> <<"shift in value">>;

growth_atom(10) -> <<"increase in margins">>;
growth_atom(11) -> <<"cost reduction">>;
growth_atom(12) -> <<"cost effectiveness">>;
growth_atom(13) -> <<"level of change">>;
growth_atom(14) -> <<"revenue growth">>;
growth_atom(15) -> <<"profits growth">>;
growth_atom(16) -> <<"growth momentum">>;
growth_atom(17) -> <<"increase in sales">>.


superlative() ->
    superlative(rand:uniform(29)).
%%
superlative(1) -> <<"organic">>;
superlative(2) -> <<"double-digit">>;
superlative(3) -> <<"upper single-digit">>;
superlative(4) -> <<"breakout">>;
superlative(5) -> <<"unprecedented">>;
superlative(6) -> <<"unparalleled">>;
superlative(7) -> <<"proven">>;
superlative(8) -> <<"measured">>;
superlative(9) -> <<"sustained">>;

superlative(10) -> <<"sustainable">>;
superlative(11) -> <<"robust">>;
superlative(12) -> <<"solid">>;
superlative(13) -> <<"rock-solid">>;
superlative(14) -> <<"healthy">>;
superlative(15) -> <<"incremental">>;
superlative(16) -> <<"significant">>;
superlative(17) -> <<"recurring">>;
superlative(18) -> <<"sizeable">>;
superlative(19) -> <<"rapid">>;

superlative(20) -> <<"breakneck">>;
superlative(21) -> <<"profitable">>;
superlative(22) -> <<"disciplined">>;
superlative(23) -> <<"accelerated">>;
superlative(24) -> <<"impressive">>;
superlative(25) -> <<"superior">>;
superlative(26) -> <<"attractive-enough">>;
superlative(27) -> <<"continual">>;
superlative(28) -> <<"above-potential">>;
superlative(29) -> <<"better-than-average">>.

%% Can be made plural
thing_atom_inner() ->
    thing_atom_inner(rand:uniform(253)).
%%
thing_atom_inner(1)   -> <<"mission">>;
thing_atom_inner(2)   -> <<"vision">>;
thing_atom_inner(3)   -> <<"guideline">>;
thing_atom_inner(4)   -> <<"roadmap">>;
thing_atom_inner(5)   -> <<"timeline">>;
thing_atom_inner(6)   -> matrix_or_so();
thing_atom_inner(7)   -> <<"win-win solution">>;
thing_atom_inner(8)   -> <<"baseline starting point">>;
thing_atom_inner(9)   -> <<"sign-off">>;

thing_atom_inner(10)  -> <<"escalation">>;
thing_atom_inner(11)  -> <<"system">>;
thing_atom_inner(12)  -> abbreviate(<<"Management Information System">>, 0.5);
thing_atom_inner(13)  -> abbreviate(<<"Quality Management System">>, 0.5);
thing_atom_inner(14)  -> <<"planning">>;
thing_atom_inner(15)  -> <<"target">>;
thing_atom_inner(16)  -> <<"calibration">>;
thing_atom_inner(17)  -> abbreviate(<<"Control Information System">>, 0.5);
thing_atom_inner(18)  -> <<"process">>;
thing_atom_inner(19)  -> <<"talent">>;

thing_atom_inner(20)  -> <<"execution">>;
thing_atom_inner(21)  -> <<"leadership">>;
thing_atom_inner(22)  -> <<"performance">>;
thing_atom_inner(23)  -> <<"solution provider">>;
thing_atom_inner(24)  -> <<"value">>;
thing_atom_inner(25)  -> <<"value creation">>;
thing_atom_inner(26)  -> <<"value realization">>;
thing_atom_inner(27)  -> <<"document">>;
thing_atom_inner(28)  -> <<"bottom line">>;
thing_atom_inner(29)  -> <<"momentum">>;

thing_atom_inner(30)  -> <<"opportunity">>;
thing_atom_inner(31)  -> <<"credibility">>;
thing_atom_inner(32)  -> <<"issue">>;
thing_atom_inner(33)  -> <<"core meeting">>;
thing_atom_inner(34)  -> <<"platform">>;
thing_atom_inner(35)  -> <<"niche">>;
thing_atom_inner(36)  -> <<"content">>;
thing_atom_inner(37)  -> <<"communication">>;
thing_atom_inner(38)  -> <<"goal">>;
thing_atom_inner(39)  -> <<"value creation goal">>;

thing_atom_inner(40)  -> <<"alternative">>;
thing_atom_inner(41)  -> <<"culture">>;
thing_atom_inner(42)  -> <<"requirement">>;
thing_atom_inner(43)  -> <<"potential">>;
thing_atom_inner(44)  -> <<"challenge">>;
thing_atom_inner(45)  -> <<"empowerment">>;
thing_atom_inner(46)  -> <<"benchmarking">>;
thing_atom_inner(47)  -> <<"framework">>;
thing_atom_inner(48)  -> <<"benchmark">>;
thing_atom_inner(49)  -> <<"implication">>;

thing_atom_inner(50)  -> <<"integration">>;
thing_atom_inner(51)  -> <<"enabler">>;   % also person
thing_atom_inner(52)  -> <<"control">>;
thing_atom_inner(53)  -> <<"trend">>;
thing_atom_inner(54)  -> <<"business case">>;
thing_atom_inner(55)  -> <<"architecture">>;
thing_atom_inner(56)  -> <<"action plan">>;
thing_atom_inner(57)  -> <<"project">>;
thing_atom_inner(58)  -> <<"review cycle">>;
thing_atom_inner(59)  -> <<"trigger event">>;

thing_atom_inner(60)  -> <<"strategy formulation">>;
thing_atom_inner(61)  -> <<"decision">>;
thing_atom_inner(62)  -> <<"enhanced data capture">>;
thing_atom_inner(63)  -> <<"energy">>;
thing_atom_inner(64)  -> <<"plan">>;
thing_atom_inner(65)  -> <<"initiative">>;
thing_atom_inner(66)  -> <<"priority">>;
thing_atom_inner(67)  -> <<"synergy">>;
thing_atom_inner(68)  -> <<"incentive">>;
thing_atom_inner(69)  -> <<"dialogue">>;

thing_atom_inner(70)  -> <<"concept">>;
thing_atom_inner(71)  -> <<"time-phase">>;
thing_atom_inner(72)  -> <<"projection">>;
thing_atom_inner(73)  -> <<"blended approach">>;
thing_atom_inner(74)  -> <<"low hanging fruit">>;
thing_atom_inner(75)  -> <<"forward planning">>;
thing_atom_inner(76)  -> <<"pre-plan">>;   % also a verb
thing_atom_inner(77)  -> <<"pipeline">>;
thing_atom_inner(78)  -> <<"bandwidth">>;
thing_atom_inner(79)  -> <<"brand image">>;

thing_atom_inner(80)  -> <<"paradigm">>;
thing_atom_inner(81)  -> <<"paradigm shift">>;
thing_atom_inner(82)  -> <<"strategic staircase">>;
thing_atom_inner(83)  -> <<"cornerstone">>;
thing_atom_inner(84)  -> <<"executive talent">>;
thing_atom_inner(85)  -> <<"evolution">>;
thing_atom_inner(86)  -> <<"workflow">>;
thing_atom_inner(87)  -> <<"message">>;
thing_atom_inner(88)  -> <<"risk/return profile">>;
thing_atom_inner(89)  -> <<"efficient frontier">>;

thing_atom_inner(90)  -> <<"pillar">>;
thing_atom_inner(91)  -> <<"internal client">>;
thing_atom_inner(92)  -> <<"consistency">>;
thing_atom_inner(93)  -> <<"on-boarding process">>;
thing_atom_inner(94)  -> <<"dotted line">>;
thing_atom_inner(95)  -> <<"action item">>;
thing_atom_inner(96)  -> <<"cost efficiency">>;
thing_atom_inner(97)  -> <<"channel">>;
thing_atom_inner(98)  -> <<"convergence">>;
thing_atom_inner(99)  -> <<"infrastructure">>;

thing_atom_inner(100) -> <<"metric">>;
thing_atom_inner(101) -> <<"technology">>;
thing_atom_inner(102) -> <<"relationship">>;
thing_atom_inner(103) -> <<"partnership">>;
thing_atom_inner(104) -> <<"supply-chain">>;
thing_atom_inner(105) -> <<"portal">>;
thing_atom_inner(106) -> <<"solution">>;
thing_atom_inner(107) -> <<"business line">>;
thing_atom_inner(108) -> <<"white paper">>;
thing_atom_inner(109) -> <<"scalability">>;

thing_atom_inner(110) -> <<"innovation">>;
thing_atom_inner(111) -> abbreviate(<<"Strategic Management System">>, 0.5);
thing_atom_inner(112) -> <<"Balanced Scorecard">>;
thing_atom_inner(113) -> <<"key differentiator">>;
thing_atom_inner(114) -> <<"case study">>;
thing_atom_inner(115) -> <<"idiosyncrasy">>;
thing_atom_inner(116) -> <<"benefit">>;
thing_atom_inner(117) -> <<"say/do ratio">>;
thing_atom_inner(118) -> <<"segmentation">>;
thing_atom_inner(119) -> <<"image">>;

thing_atom_inner(120) -> <<"realignment">>;
thing_atom_inner(121) -> <<"business model">>;
thing_atom_inner(122) -> <<"business philosophy">>;
thing_atom_inner(123) -> <<"business platform">>;
thing_atom_inner(124) -> <<"methodology">>;
thing_atom_inner(125) -> <<"profile">>;
thing_atom_inner(126) -> <<"measure">>;
thing_atom_inner(127) -> <<"measurement">>;
thing_atom_inner(128) -> <<"philosophy">>;
thing_atom_inner(129) -> <<"branding strategy">>;

thing_atom_inner(130) -> <<"efficiency">>;
thing_atom_inner(131) -> <<"industry">>;
thing_atom_inner(132) -> <<"commitment">>;
thing_atom_inner(133) -> <<"perspective">>;
thing_atom_inner(134) -> <<"risk appetite">>;
thing_atom_inner(135) -> <<"best practice">>;
thing_atom_inner(136) -> <<"brand identity">>;
thing_atom_inner(137) -> <<"customer centricity">>;
thing_atom_inner(138) -> <<"shareholder value">>;
thing_atom_inner(139) -> <<"attitude">>;

thing_atom_inner(140) -> <<"mindset">>;
thing_atom_inner(141) -> <<"flexibility">>;
thing_atom_inner(142) -> <<"granularity">>;
thing_atom_inner(143) -> <<"engagement">>;
thing_atom_inner(144) -> <<"pyramid">>;
thing_atom_inner(145) -> <<"market">>;
thing_atom_inner(146) -> <<"diversity">>;
thing_atom_inner(147) -> <<"interdependency">>;
thing_atom_inner(148) -> <<"scaling">>;
thing_atom_inner(149) -> <<"asset">>;

thing_atom_inner(150) -> <<"flow charting">>;
thing_atom_inner(151) -> <<"value proposition">>;
thing_atom_inner(152) -> <<"performance culture">>;
thing_atom_inner(153) -> <<"change">>;
thing_atom_inner(154) -> <<"reward">>;
thing_atom_inner(155) -> <<"learning">>;
thing_atom_inner(156) -> <<"next step">>;
thing_atom_inner(157) -> <<"delivery framework">>;
thing_atom_inner(158) -> <<"structure">>;
thing_atom_inner(159) -> <<"support structure">>;

thing_atom_inner(160) -> <<"standardization">>;
thing_atom_inner(161) -> <<"objective">>;
thing_atom_inner(162) -> <<"footprint">>;
thing_atom_inner(163) -> <<"transformation process">>;
thing_atom_inner(164) -> <<"policy">>;
thing_atom_inner(165) -> <<"sales target">>;
thing_atom_inner(166) -> <<"ecosystem">>;
thing_atom_inner(167) -> <<"landscape">>;
thing_atom_inner(168) -> <<"atmosphere">>;
thing_atom_inner(169) -> <<"environment">>;

thing_atom_inner(170) -> <<"core competency">>;
thing_atom_inner(171) -> <<"market practice">>;
thing_atom_inner(172) -> <<"operating strategy">>;
thing_atom_inner(173) -> <<"insight">>;
thing_atom_inner(174) -> <<"accomplishment">>;
thing_atom_inner(175) -> <<"correlation">>;
thing_atom_inner(176) -> <<"touchpoint">>;
thing_atom_inner(177) -> <<"knowledge transfer">>;
thing_atom_inner(178) -> <<"correlation">>;
thing_atom_inner(179) -> <<"capability">>;

thing_atom_inner(180) -> <<"gamification">>;
thing_atom_inner(181) -> <<"smooth transition">>;
thing_atom_inner(182) -> <<"leadership strategy">>;
thing_atom_inner(183) -> <<"collaboration">>;
thing_atom_inner(184) -> <<"success factor">>;
thing_atom_inner(185) -> <<"lever">>;
thing_atom_inner(186) -> <<"breakthrough">>;
thing_atom_inner(187) -> <<"open-door policy">>;
thing_atom_inner(188) -> <<"recalibration">>;
thing_atom_inner(189) -> <<"wow factor">>;

thing_atom_inner(190) -> <<"onboarding solution">>;
thing_atom_inner(191) -> <<"brand pyramid">>;
thing_atom_inner(192) -> <<"dashboard">>;
thing_atom_inner(193) -> <<"branding">>;
thing_atom_inner(194) -> <<"local-for-local strategy">>;
thing_atom_inner(195) -> <<"cross-sell message">>;
thing_atom_inner(196) -> <<"up-sell message">>;
thing_atom_inner(197) -> <<"divisional structure">>;
thing_atom_inner(198) -> <<"value chain">>;
thing_atom_inner(199) -> <<"microsegment">>;

thing_atom_inner(200) -> <<"rollout plan">>;
thing_atom_inner(201) -> abbreviate(<<"Leadership Development System">>, 0.5);
thing_atom_inner(202) -> <<"architectural approach">>;
thing_atom_inner(203) -> <<"brand value">>;
thing_atom_inner(204) -> <<"milestone">>;
thing_atom_inner(205) -> <<"co-innovation">>;
thing_atom_inner(206) -> <<"speedup">>;
thing_atom_inner(207) -> <<"validation">>;
thing_atom_inner(208) -> <<"skill">>;
thing_atom_inner(209) -> <<"skillset">>;

thing_atom_inner(210) -> <<"feedback">>;
thing_atom_inner(211) -> <<"learnability">>;
thing_atom_inner(212) -> <<"visibility">>;
thing_atom_inner(213) -> <<"agility">>;
thing_atom_inner(214) -> <<"simplification">>;
thing_atom_inner(215) -> <<"digitization">>;
thing_atom_inner(216) -> <<"streamlining">>;
thing_atom_inner(217) -> <<"brainstorming space">>;
thing_atom_inner(218) -> <<"crowdsourcing">>;
thing_atom_inner(219) -> <<"big-bang approach">>;

thing_atom_inner(220) -> <<"execution message">>;
thing_atom_inner(221) -> <<"criticality">>;
thing_atom_inner(222) -> <<"opportunity pipeline">>;
thing_atom_inner(223) -> <<"reorganization">>;
thing_atom_inner(224) -> <<"synergization">>;
thing_atom_inner(225) -> <<"socialization">>;
thing_atom_inner(226) -> <<"strategic shift">>;
thing_atom_inner(227) -> <<"growth engine">>;
thing_atom_inner(228) -> <<"tailwind">>;
thing_atom_inner(229) -> <<"accelerator">>;

thing_atom_inner(230) -> <<"deliverable">>;
thing_atom_inner(231) -> <<"takeaway">>;
thing_atom_inner(232) -> <<"insourcing">>;
thing_atom_inner(233) -> <<"outsourcing">>;
thing_atom_inner(234) -> <<"careful consideration">>;
thing_atom_inner(235) -> <<"conviction">>;
thing_atom_inner(236) -> <<"initiator">>;
thing_atom_inner(237) -> <<"operating model">>;
thing_atom_inner(238) -> <<"proof-point">>;
thing_atom_inner(239) -> <<"bounce rate">>;

thing_atom_inner(240) -> <<"marketing funnel">>;
thing_atom_inner(241) -> <<"offshoring">>;
thing_atom_inner(242) -> <<"quick-win">>;
thing_atom_inner(243) -> <<"cross-pollination">>;
thing_atom_inner(244) -> <<"hybridation">>;
thing_atom_inner(245) -> <<"positioning">>;
thing_atom_inner(246) -> <<"reinvention">>;
thing_atom_inner(247) -> <<"functionality">>;
thing_atom_inner(248) -> <<"mindshare">>;
thing_atom_inner(249) -> <<"mobility space">>;

thing_atom_inner(250) -> <<"decision-to-execution cycle">>;
thing_atom_inner(251) -> <<"adjustment">>;
thing_atom_inner(252) -> <<"force management program">>;
thing_atom_inner(253) -> <<"launchpad">>.

thing_atom(false) ->
    %% assume equiprobability between explicit singular and
    %% "others => ..." items
    thing_atom_singular(rand:uniform(430));
thing_atom(true) ->
    %% assume equiprobability between explicit plural and
    %% "others => ..." items
    thing_atom_plural(rand:uniform(287)).

%% Things where plural would sound clunky
thing_atom_singular(1)   -> timeless_event();
thing_atom_singular(2)   -> <<"team building">>;
thing_atom_singular(3)   -> <<"focus">>;
thing_atom_singular(4)   -> <<"strategy">>;
thing_atom_singular(5)   -> <<"planning granularity">>;
thing_atom_singular(6)   -> <<"core business">>;
thing_atom_singular(7)   -> <<"implementation">>;
thing_atom_singular(8)   -> <<"intelligence">>;
thing_atom_singular(9)   -> <<"change management">>;

thing_atom_singular(10)  -> <<"ROE">>;
thing_atom_singular(11)  -> <<"EBITDA">>;
thing_atom_singular(12)  -> <<"enterprise content management">>;
thing_atom_singular(13)  -> <<"excellence">>;
thing_atom_singular(14)  -> <<"trust">>;
thing_atom_singular(15)  -> <<"respect">>;
thing_atom_singular(16)  -> <<"openness">>;
thing_atom_singular(17)  -> <<"transparency">>;
thing_atom_singular(18)  -> abbreviate(<<"Quality Research">>, 0.5);
thing_atom_singular(19)  -> <<"decision making">>;

thing_atom_singular(20)  -> <<"risk management">>;
thing_atom_singular(21)  -> <<"enterprise risk management">>;
thing_atom_singular(22)  -> <<"leverage">>;
thing_atom_singular(23)  -> <<"diversification">>;
thing_atom_singular(24)  -> <<"successful execution">>;
thing_atom_singular(25)  -> <<"effective execution">>;
thing_atom_singular(26)  -> <<"selectivity">>;
thing_atom_singular(27)  -> <<"optionality">>;
thing_atom_singular(28)  -> <<"expertise">>;
thing_atom_singular(29)  -> <<"awareness">>;

thing_atom_singular(30)  -> <<"broader thinking">>;
thing_atom_singular(31)  -> <<"client focus">>;
thing_atom_singular(32)  -> <<"thought leadership">>;
thing_atom_singular(33)  -> <<"quest for quality">>;
thing_atom_singular(34)  -> <<"360-degree thinking">>;
thing_atom_singular(35)  -> <<"drill-down">>;
thing_atom_singular(36)  -> <<"impetus">>;
thing_atom_singular(37)  -> <<"fairness">>;
thing_atom_singular(38)  -> <<"intellect">>;
thing_atom_singular(39)  -> <<"emotional impact">>;

thing_atom_singular(40)  -> <<"emotional intelligence">>;
thing_atom_singular(41)  -> <<"adaptability">>;
thing_atom_singular(42)  -> <<"stress management">>;
thing_atom_singular(43)  -> <<"self-awareness">>;
thing_atom_singular(44)  -> <<"strategic thinking">>;
thing_atom_singular(45)  -> <<"cross-fertilization">>;
thing_atom_singular(46)  -> <<"cross-breeding">>;
thing_atom_singular(47)  -> <<"customer experience">>;
thing_atom_singular(48)  -> <<"centerpiece">>;
thing_atom_singular(49)  -> <<"SWOT analysis">>;

thing_atom_singular(50)  -> <<"responsibility">>;
thing_atom_singular(51)  -> <<"accountability">>;
thing_atom_singular(52)  -> <<"ROI">>;
thing_atom_singular(53)  -> <<"line of business">>;
thing_atom_singular(54)  -> <<"serviceability">>;
thing_atom_singular(55)  -> <<"responsiveness">>;
thing_atom_singular(56)  -> <<"simplicity">>;
thing_atom_singular(57)  -> <<"portfolio shaping">>;
thing_atom_singular(58)  -> <<"knowledge sharing">>;
thing_atom_singular(59)  -> <<"continuity">>;

thing_atom_singular(60)  -> <<"visual thinking">>;
thing_atom_singular(61)  -> <<"interoperability">>;
thing_atom_singular(62)  -> <<"compliance">>;
thing_atom_singular(63)  -> <<"teamwork">>;
thing_atom_singular(64)  -> <<"self-efficacy">>;
thing_atom_singular(65)  -> <<"decision-making">>;
thing_atom_singular(66)  -> <<"line-of-sight">>;
thing_atom_singular(67)  -> <<"scoping">>;
thing_atom_singular(68)  -> <<"line-up">>;
thing_atom_singular(69)  -> <<"predictability">>;

thing_atom_singular(70)  -> <<"recognition">>;
thing_atom_singular(71)  -> <<"investor confidence">>;
thing_atom_singular(72)  -> <<"competitive advantage">>;
thing_atom_singular(73)  -> <<"uniformity">>;
thing_atom_singular(74)  -> <<"connectivity">>;
thing_atom_singular(75)  -> <<"big picture">>;
thing_atom_singular(76)  -> <<"big-picture thinking">>;
thing_atom_singular(77)  -> <<"quality">>;
thing_atom_singular(78)  -> <<"upside focus">>;
thing_atom_singular(79)  -> <<"sustainability">>;

thing_atom_singular(80)  -> <<"resiliency">>;
thing_atom_singular(81)  -> <<"social sphere">>;
thing_atom_singular(82)  -> <<"intuitiveness">>;
thing_atom_singular(83)  -> <<"effectiveness">>;
thing_atom_singular(84)  -> <<"competitiveness">>;
thing_atom_singular(85)  -> <<"resourcefulness">>;
thing_atom_singular(86)  -> <<"informationalization">>;
thing_atom_singular(87)  -> <<"role building">>;
thing_atom_singular(88)  -> <<"talent retention">>;
thing_atom_singular(89)  -> <<"innovativeness">>;

thing_atom_singular(90)  -> <<"Economic Value Creation">>;
thing_atom_singular(91)  -> <<"intellectual capital">>;
thing_atom_singular(92)  -> <<"high quality">>;
thing_atom_singular(93)  -> <<"full range of products">>;
thing_atom_singular(94)  -> <<"technical strength">>;
thing_atom_singular(95)  -> <<"quality assurance">>;
thing_atom_singular(96)  -> <<"specification quality">>;
thing_atom_singular(97)  -> <<"market environment">>;
thing_atom_singular(98)  -> <<"client perspective">>;
thing_atom_singular(99)  -> <<"solution orientation">>;

thing_atom_singular(100) -> <<"client satisfaction">>;
thing_atom_singular(101) -> <<"integrity">>;
thing_atom_singular(102) -> <<"reputation">>;
thing_atom_singular(103) -> <<"time-to-market">>;
thing_atom_singular(104) -> <<"innovative edge">>;
thing_atom_singular(105) -> <<"book value growth">>;
thing_atom_singular(106) -> <<"global network">>;
thing_atom_singular(107) -> <<"ability to deliver">>;
thing_atom_singular(108) -> <<"active differentiation">>;
thing_atom_singular(109) -> <<"solid profitability">>;

thing_atom_singular(110) -> <<"core capacity">>;
thing_atom_singular(111) -> <<"digital economy">>;
thing_atom_singular(112) -> <<"white-collar productivity">>;
thing_atom_singular(113) -> <<"white-collar efficiency">>;
thing_atom_singular(114) -> <<"governance">>;
thing_atom_singular(115) -> <<"corporate governance">>;
thing_atom_singular(116) -> <<"business development">>;
thing_atom_singular(117) -> <<"corporate identity">>;
thing_atom_singular(118) -> <<"attractiveness">>;
thing_atom_singular(119) -> <<"design philosophy">>;

thing_atom_singular(120) -> <<"global footprint">>;
thing_atom_singular(121) -> <<"risk taking">>;
thing_atom_singular(122) -> <<"focus on speed">>;
thing_atom_singular(123) -> <<"business equation">>;
thing_atom_singular(124) -> <<"edge">>;
thing_atom_singular(125) -> <<"ownership">>;
thing_atom_singular(126) -> <<"competitive success">>;
thing_atom_singular(127) -> <<"discipline">>;
thing_atom_singular(128) -> <<"knowledge management">>;
thing_atom_singular(129) -> <<"ability to move fast">>;

thing_atom_singular(130) -> <<"ingenuity">>;
thing_atom_singular(131) -> <<"insightfulness">>;
thing_atom_singular(132) -> <<"integrativeness">>;
thing_atom_singular(133) -> <<"customer footprint">>;
thing_atom_singular(134) -> <<"time-to-value">>;
thing_atom_singular(135) -> <<"efficacy">>;
thing_atom_singular(136) -> <<"DNA">>;
thing_atom_singular(137) -> <<"dedication">>;
thing_atom_singular(138) -> <<"franchise">>;
thing_atom_singular(139) -> <<"global reach">>;

thing_atom_singular(140) -> <<"global touch-base">>;
thing_atom_singular(141) -> <<"technical excellence">>;
thing_atom_singular(142) -> <<"values congruence">>;
thing_atom_singular(143) -> <<"purpose">>;
thing_atom_singular(144) -> <<"catalyst for growth">>;
thing_atom_singular(145) -> <<"goal setting">>;
thing_atom_singular(146) -> <<"craftsmanship">>;
thing_atom_singular(147) -> <<"operational excellence">>;
thing_atom_singular(148) -> <<"re-engineering">>;
thing_atom_singular(149) -> <<"mindfulness">>;

thing_atom_singular(150) -> <<"quality thinking">>;
thing_atom_singular(151) -> <<"user experience">>;
thing_atom_singular(152) -> <<"speed of execution">>;
thing_atom_singular(153) -> <<"responsive design">>;
thing_atom_singular(154) -> <<"readiness to go \"all-in\"">>;
thing_atom_singular(155) -> <<"machine intelligence">>;
thing_atom_singular(156) -> <<"creativity">>;
thing_atom_singular(157) -> <<"can-do attitude">>;
thing_atom_singular(158) -> <<"relevance">>;
thing_atom_singular(159) -> <<"disruption">>;

thing_atom_singular(160) -> <<"dematerialization">>;
thing_atom_singular(161) -> <<"disintermediation">>;
thing_atom_singular(162) -> <<"disaggregation">>;
thing_atom_singular(163) -> <<"wave of change">>;
thing_atom_singular(164) -> <<"digitalization">>;
thing_atom_singular(165) -> <<"CAPEX">>;
thing_atom_singular(166) -> <<"window of opportunity">>;
thing_atom_singular(167) -> <<"beta">>;
thing_atom_singular(168) -> <<"coopetition">>;
thing_atom_singular(169) -> <<"digital change">>;

thing_atom_singular(170) -> <<"business excellence">>;
thing_atom_singular(171) -> <<"business impact">>;
thing_atom_singular(172) -> <<"business acumen">>;
thing_atom_singular(173) -> <<"leadership culture">>;
thing_atom_singular(174) -> <<"glocalization">>;
thing_atom_singular(175) -> <<"re-equitizing">>;
thing_atom_singular(176) -> <<"cost rationalization">>;
thing_atom_singular(177) -> <<"strategic optionality">>;
thing_atom_singular(_)   ->
    %% Equiprobable:
    thing_atom_inner().

%% Things you find usually as plural
thing_atom_plural(1)   -> <<"key target markets">>;
thing_atom_plural(2)   -> <<"style guidelines">>;
thing_atom_plural(3)   -> <<"key performance indicators">>;
thing_atom_plural(4)   -> <<"market conditions">>;
thing_atom_plural(5)   -> <<"market forces">>;
thing_atom_plural(6)   -> <<"market opportunities">>;
thing_atom_plural(7)   -> <<"tactics">>;
thing_atom_plural(8)   -> <<"organizing principles">>;
thing_atom_plural(9)   -> <<"interpersonal skills">>;

thing_atom_plural(10)  -> <<"roles and responsibilities">>;
thing_atom_plural(11)  -> <<"cost savings">>;
thing_atom_plural(12)  -> <<"lessons learned">>;
thing_atom_plural(13)  -> <<"client needs">>;
thing_atom_plural(14)  -> <<"requests / solutions">>;
thing_atom_plural(15)  -> <<"mobile strategies">>;
thing_atom_plural(16)  -> <<"expectations and allocations">>;
thing_atom_plural(17)  -> <<"workshops">>;
thing_atom_plural(18)  -> <<"dynamics">>;
thing_atom_plural(19)  -> <<"options">>;

thing_atom_plural(20)  -> <<"aspirations">>;
thing_atom_plural(21)  -> <<"swim lanes">>;
thing_atom_plural(22)  -> <<"pockets of opportunities">>;
thing_atom_plural(23)  -> <<"social implications">>;
thing_atom_plural(24)  -> <<"analytics">>;
thing_atom_plural(25)  -> <<"advanced analytics">>;
thing_atom_plural(26)  -> <<"growth years">>;
thing_atom_plural(27)  -> <<"big data">>;
thing_atom_plural(28)  -> <<"adjacencies">>;
thing_atom_plural(29)  -> <<"core competences">>;

thing_atom_plural(30)  -> <<"strengths">>;
thing_atom_plural(31)  -> <<"corporate values">>;
thing_atom_plural(32)  -> <<"core value">>;
thing_atom_plural(33)  -> <<"competitive dynamics">>;
thing_atom_plural(34)  -> <<"workforce adjustments">>;
thing_atom_plural(_)   ->
    %% Equiprobable:
    make_eventual_plural(thing_atom_inner(), true).


thing(Plural) ->
    thing(rand:uniform(160), Plural).
%%
thing(R, Plural) when 1 =< R, R =< 9 ->
    %% 2 adjectives, comma separated
    Adj1 = thing_adjective(),
    Adj2 = thing_adjective(),
    Atom = thing_atom(Plural),
    <<Adj1/binary,", ",
      Adj2/binary,", ",
      Atom/binary>>;
thing(R, Plural) when 10 =< R, R =< 14 ->
    %% 2 adjectives, separated by "and"
    Adj1 = thing_adjective(),
    Adj2 = thing_adjective(),
    Atom = thing_atom(Plural),
    <<Adj1/binary," and ",
      Adj2/binary," ",
      Atom/binary>>;
thing(R, Plural) when 15 =< R, R =< 80 ->
    %% 1 adjective
    A1 = thing_adjective(),
    T1 = thing_atom(Plural),
    <<A1/binary," ",T1/binary>>;
thing(R, Plural) when 81 =< R, R =< 82 ->
    %% 2 adjectives, separated by "and/or"
    Adj1 = thing_adjective(),
    Adj2 = thing_adjective(),
    Atom = thing_atom(Plural),
    <<Adj1/binary," and/or ",
      Adj2/binary," ",
      Atom/binary>>;
thing(R, _Plural) when 83 =< R, R =< 84 ->
    %% already has a superlative, don't add an adjective
    growth();
thing(R, Plural) when 85 =< R, R =< 90 ->
    %% 3 adjectives
    Adj1 = thing_adjective(),
    Adj2 = thing_adjective(),
    Adj3 = thing_adjective(),
    Atom = thing_atom(Plural),
    <<Adj1/binary,", ",
      Adj2/binary," and ",
      Adj3/binary," ",
      Atom/binary>>;
thing(R, Plural) when 91 =< R, R =< 94 ->
    %% 4 adjectives
    Adj1 = thing_adjective(),
    Adj2 = thing_adjective(),
    Adj3 = thing_adjective(),
    Adj4 = thing_adjective(),
    Atom = thing_atom(Plural),
    <<Adj1/binary,", ",
      Adj2/binary,", ",
      Adj3/binary," and ",
      Adj4/binary," ",
      Atom/binary>>;
thing(_, Plural) ->
    thing_atom(Plural).


random_plural() ->
    case rand:uniform(2) of
	1 ->
	    true;
	2 ->
	    false
    end.



%%--------------------------------------------------------------------------
%%   The Bad Things. Whaaaa!
%%--------------------------------------------------------------------------
%%   They are always in plural. Singular is avoided for two reasons:
%%   1. It would be too specific - someone would be tempted to ask for
%%      details!
%%   2. It may be the beginning of a finger-pointing session. Better stay
%%      impersonal to survive the meeting...
%%--------------------------------------------------------------------------
bad_things() ->
    bad_things(rand:uniform(44)).
%%
bad_things(1)  -> <<"issues">>;
bad_things(2)  -> <<"intricacies">>;
bad_things(3)  -> <<"organizational diseconomies">>;
bad_things(4)  -> <<"black swans">>;
bad_things(5)  -> <<"challenging market conditions">>;
bad_things(6)  -> <<"inefficiencies">>;
bad_things(7)  -> <<"overlaps">>;
bad_things(8)  -> <<"known unknowns">>;
bad_things(9)  -> <<"unknown unknowns">>;

bad_things(10) -> <<"soft cycle issues">>;
bad_things(11) -> <<"obstacles">>;
bad_things(12) -> <<"surprises">>;
bad_things(13) -> <<"weaknesses">>;
bad_things(14) -> <<"threats">>;
bad_things(15) -> <<"barriers to success">>;
bad_things(16) -> <<"barriers">>;
bad_things(17) -> <<"shortcomings">>;
bad_things(18) -> <<"problems">>;
bad_things(19) -> <<"uncertainties">>;

bad_things(20) -> <<"unfavorable developments">>;
bad_things(21) -> <<"consumer/agent disconnects">>;
bad_things(22) -> <<"underperforming areas">>;
bad_things(23) -> <<"information overloads">>;
bad_things(24) -> <<"concerns">>;
bad_things(25) -> <<"shortfalls">>;
bad_things(26) -> <<"limitations">>;
bad_things(27) -> <<"downtimes">>;
bad_things(28) -> <<"headwinds">>;
bad_things(29) -> <<"subpar returns">>;

bad_things(30) -> <<"gaps">>;
bad_things(31) -> <<"market gaps">>;
bad_things(32) -> <<"pitfalls">>;
bad_things(33) -> <<"constraints">>;
bad_things(34) -> <<"problems/difficulties">>;
bad_things(35) -> <<"bottlenecks">>;
bad_things(36) -> <<"misunderstandings">>;
bad_things(37) -> <<"dilemmas">>;
bad_things(38) -> <<"interdependencies">>;
bad_things(39) -> <<"discontinuities">>;

bad_things(40) -> <<"hiccups">>;
bad_things(41) -> <<"vulnerabilities">>;
bad_things(42) -> <<"negative cash flows">>;
bad_things(43) -> <<"net profit revenue deficiencies">>;
bad_things(44) -> <<"negative contributions to profit">>.



%%%=========================================================================
%%%  Verbs
%%%=========================================================================

eventual_adverb() ->
    eventual_adverb(rand:uniform(120)).
%% proportion: 3/4 empty adverb
eventual_adverb(1)  -> <<"interactively ">>;
eventual_adverb(2)  -> <<"credibly ">>;
eventual_adverb(3)  -> <<"quickly ">>;
eventual_adverb(4)  -> <<"proactively ">>;
eventual_adverb(5)  -> <<"200% ">>;
eventual_adverb(6)  -> <<"24/7 ">>;
eventual_adverb(7)  -> <<"globally ">>;
eventual_adverb(8)  -> <<"culturally ">>;
eventual_adverb(9)  -> <<"technically ">>;

eventual_adverb(10) -> <<"strategically ">>;
eventual_adverb(11) -> <<"swiftly ">>;
eventual_adverb(12) -> <<"cautiously ">>;
eventual_adverb(13) -> <<"expediently ">>;
eventual_adverb(14) -> <<"organically ">>;
eventual_adverb(15) -> <<"carefully ">>;
eventual_adverb(16) -> <<"significantly ">>;
eventual_adverb(17) -> <<"conservatively ">>;
eventual_adverb(18) -> <<"adequately ">>;
eventual_adverb(19) -> <<"genuinely ">>;

eventual_adverb(20) -> <<"efficiently ">>;
eventual_adverb(21) -> <<"seamlessly ">>;
eventual_adverb(22) -> <<"consistently ">>;
eventual_adverb(23) -> <<"diligently ">>;
eventual_adverb(24) -> <<"dramatically ">>;
eventual_adverb(25) -> <<"straightforwardly ">>;
eventual_adverb(26) -> <<"differentially ">>;
eventual_adverb(27) -> <<"gradually ">>;
eventual_adverb(28) -> <<"aggressively ">>;
eventual_adverb(29) -> <<"cost-effectively ">>;
eventual_adverb(30) -> <<"proactively ">>;
eventual_adverb(_)  -> <<"">>.


add_random_article(S, Plural) ->
    case rand:uniform(15) of
	R when R =:= 1; R =:= 2 ->
	    <<"the ",S/binary>>;
	R when 3 =< R, R =< 6 ->
	    <<"our ",S/binary>>;
	%% Indefinite is preferred in BS language.
	R when 7 =< R, R =< 15 ->
	    add_indefinite_article(S, Plural)
    end.


eventual_postfixed_adverb() ->
    eventual_postfixed_adverb(rand:uniform(235),random_plural()).
%% proportion: ~ 4/5 empty postfixed adverb
eventual_postfixed_adverb(1, _)  -> <<" going forward">>;
eventual_postfixed_adverb(2, _)  -> <<" within the industry">>;
eventual_postfixed_adverb(3, _)  -> <<" across the board">>;
eventual_postfixed_adverb(4, _)  -> <<" in this space">>;
eventual_postfixed_adverb(5, _)  -> <<" from the get-go">>;
eventual_postfixed_adverb(6, _)  -> <<" at the end of the day">>;
eventual_postfixed_adverb(7, _)  -> <<" throughout the organization">>;
eventual_postfixed_adverb(8, _)  -> <<" as part of the plan">>;
eventual_postfixed_adverb(9, _)  -> <<" by thinking outside of the box">>;

eventual_postfixed_adverb(10, P) ->
    T = add_random_article(thing(P),P),
    <<" using ",T/binary>>;
eventual_postfixed_adverb(11, P) ->
    T = add_random_article(thing(P),P),
    <<" by leveraging ",T/binary>>;
eventual_postfixed_adverb(12, P) ->
    T = add_random_article(thing(P),P),
    <<" taking advantage of ",T/binary>>;
eventual_postfixed_adverb(13, _) ->
    M = matrix_or_so(),
    <<" within the ",M/binary>>;
eventual_postfixed_adverb(14, _) ->
    M = make_eventual_plural(matrix_or_so(), true),
    <<" across the ",M/binary>>;
eventual_postfixed_adverb(15, _) ->
    M = make_eventual_plural(matrix_or_so(), true),
    <<" across and beyond the ",M/binary>>;
eventual_postfixed_adverb(16, _) ->
    G = add_indefinite_article(growth(), false),
    <<" resulting in ",G/binary>>;
eventual_postfixed_adverb(17, _) ->
    G = growth(),
    <<" reaped from our ",G/binary>>;
eventual_postfixed_adverb(18, _) ->
    G = add_indefinite_article(growth(), false),
    <<" as a consequence of ",G/binary>>;
eventual_postfixed_adverb(19, P) ->
    T = add_random_article(thing(P),P),
    V = build_plural_verb(<<"produce">>, P),
    G = add_indefinite_article(growth(), false),
    <<" because ",T/binary," ",V/binary," ",G/binary>>;

eventual_postfixed_adverb(20, _) -> <<" ahead of schedule">>;
eventual_postfixed_adverb(21, _) -> <<", relative to our peers">>;
eventual_postfixed_adverb(22, _) -> <<" on a transitional basis">>;
eventual_postfixed_adverb(23, _) -> <<" by expanding boundaries">>;
eventual_postfixed_adverb(24, _) -> <<" by nurturing talent">>;
eventual_postfixed_adverb(25, _) -> <<", as a Tier 1 company">>;
eventual_postfixed_adverb(26, _) -> <<" up-front">>;
eventual_postfixed_adverb(27, _) -> <<" on-the-fly">>;
eventual_postfixed_adverb(28, _) -> <<" across our portfolio">>;
eventual_postfixed_adverb(29, _) -> <<" 50/50">>;

eventual_postfixed_adverb(30, _) ->
    M = matrix_or_so(),
    <<" up, down and across the ",M/binary>>;
eventual_postfixed_adverb(31, _) -> <<" in the marketplace">>;
eventual_postfixed_adverb(32, _) -> <<" by thinking and acting beyond boundaries">>;
eventual_postfixed_adverb(33, _) -> <<" at the individual, team and organizational level">>;
eventual_postfixed_adverb(34, P) ->
    T = add_indefinite_article(thing(P), P),
    <<" ensuring ",T/binary>>;
eventual_postfixed_adverb(35, _) -> <<" over the long term">>;
eventual_postfixed_adverb(36, _) -> <<" across geographies">>;
eventual_postfixed_adverb(37, _) -> <<" in the core">>;
eventual_postfixed_adverb(38, _) -> <<" across industry sectors">>;
eventual_postfixed_adverb(39, _) -> <<" across the wider Group">>;

eventual_postfixed_adverb(40, P) ->
    T = add_indefinite_article(thing(P), P),
    <<", paving the way for ",T/binary>>;
eventual_postfixed_adverb(41, _) -> <<" by levelling the playing field">>;
eventual_postfixed_adverb(42, _) -> <<" on a day-to-day basis">>;
eventual_postfixed_adverb(43, _) -> <<" across boundaries">>;
eventual_postfixed_adverb(44, _) -> <<" within the community">>;
eventual_postfixed_adverb(45, _) -> <<" from within the data">>;
eventual_postfixed_adverb(46, _) -> <<" round-the-clock">>;
eventual_postfixed_adverb(47, _) -> <<" moving forward">>;
eventual_postfixed_adverb(_, _) -> <<"">>.


person_verb_having_thing_complement(Plural, Infinitive) ->
    Inner = person_verb_having_thing_complement_inner(rand:uniform(97)),
    %% be /= are
    case Infinitive of
	true ->
	    Inner;
	false ->
	    build_plural_verb(Inner, Plural)
    end.

person_verb_having_thing_complement_inner(1) -> <<"manage">>;
person_verb_having_thing_complement_inner(2) -> <<"target">>;
person_verb_having_thing_complement_inner(3) -> <<"streamline">>;
person_verb_having_thing_complement_inner(4) -> <<"improve">>;
person_verb_having_thing_complement_inner(5) -> <<"optimize">>;
person_verb_having_thing_complement_inner(6) -> <<"achieve">>;
person_verb_having_thing_complement_inner(7) -> <<"secure">>;
person_verb_having_thing_complement_inner(8) -> <<"address">>;
person_verb_having_thing_complement_inner(9) -> <<"boost">>;

person_verb_having_thing_complement_inner(10) -> <<"deploy">>;
person_verb_having_thing_complement_inner(11) -> <<"innovate">>;
person_verb_having_thing_complement_inner(12) -> <<"right-scale">>;
person_verb_having_thing_complement_inner(13) -> <<"formulate">>;
person_verb_having_thing_complement_inner(14) -> <<"transition">>;
person_verb_having_thing_complement_inner(15) -> <<"leverage">>;
person_verb_having_thing_complement_inner(16) -> <<"focus on">>;
person_verb_having_thing_complement_inner(17) -> <<"synergize">>;
person_verb_having_thing_complement_inner(18) -> <<"generate">>;
person_verb_having_thing_complement_inner(19) -> <<"analyse">>;

person_verb_having_thing_complement_inner(20) -> <<"integrate">>;
person_verb_having_thing_complement_inner(21) -> <<"empower">>;
person_verb_having_thing_complement_inner(22) -> <<"benchmark">>;
person_verb_having_thing_complement_inner(23) -> <<"learn">>;
person_verb_having_thing_complement_inner(24) -> <<"adapt">>;
person_verb_having_thing_complement_inner(25) -> <<"enable">>;
person_verb_having_thing_complement_inner(26) -> <<"strategize">>;
person_verb_having_thing_complement_inner(27) -> <<"prioritize">>;
person_verb_having_thing_complement_inner(28) -> <<"pre-prepare">>;
person_verb_having_thing_complement_inner(29) -> <<"deliver">>;

person_verb_having_thing_complement_inner(30) -> <<"champion">>;
person_verb_having_thing_complement_inner(31) -> <<"embrace">>;
person_verb_having_thing_complement_inner(32) -> <<"enhance">>;
person_verb_having_thing_complement_inner(33) -> <<"engineer">>;
person_verb_having_thing_complement_inner(34) -> <<"envision">>;
person_verb_having_thing_complement_inner(35) -> <<"incentivize">>;
person_verb_having_thing_complement_inner(36) -> <<"maximize">>;
person_verb_having_thing_complement_inner(37) -> <<"visualize">>;
person_verb_having_thing_complement_inner(38) -> <<"whiteboard">>;
person_verb_having_thing_complement_inner(39) -> <<"institutionalize">>;

person_verb_having_thing_complement_inner(40) -> <<"promote">>;
person_verb_having_thing_complement_inner(41) -> <<"overdeliver">>;
person_verb_having_thing_complement_inner(42) -> <<"right-size">>;
person_verb_having_thing_complement_inner(43) -> <<"rebalance">>;
person_verb_having_thing_complement_inner(44) -> <<"re-imagine">>;
person_verb_having_thing_complement_inner(45) -> <<"influence">>;
person_verb_having_thing_complement_inner(46) -> <<"facilitate">>;
person_verb_having_thing_complement_inner(47) -> <<"drive">>;
person_verb_having_thing_complement_inner(48) -> <<"structure">>;
person_verb_having_thing_complement_inner(49) -> <<"standardize">>;

person_verb_having_thing_complement_inner(50) -> <<"accelerate">>;
person_verb_having_thing_complement_inner(51) -> <<"deepen">>;
person_verb_having_thing_complement_inner(52) -> <<"strengthen">>;
person_verb_having_thing_complement_inner(53) -> <<"broaden">>;
person_verb_having_thing_complement_inner(54) -> <<"enforce">>;
person_verb_having_thing_complement_inner(55) -> <<"establish">>;
person_verb_having_thing_complement_inner(56) -> <<"foster">>;
person_verb_having_thing_complement_inner(57) -> <<"build">>;
person_verb_having_thing_complement_inner(58) -> <<"differentiate">>;
person_verb_having_thing_complement_inner(59) -> <<"take a bite out of">>;

person_verb_having_thing_complement_inner(60) -> <<"table">>;
person_verb_having_thing_complement_inner(61) -> <<"flesh out">>;
person_verb_having_thing_complement_inner(62) -> <<"reach out">>;
person_verb_having_thing_complement_inner(63) -> <<"jump-start">>;
person_verb_having_thing_complement_inner(64) -> <<"co-create">>;
person_verb_having_thing_complement_inner(65) -> <<"capitalize on">>;
person_verb_having_thing_complement_inner(66) -> <<"calibrate">>;
person_verb_having_thing_complement_inner(67) -> <<"re-aggregate">>;
person_verb_having_thing_complement_inner(68) -> <<"articulate">>;
person_verb_having_thing_complement_inner(69) -> <<"iterate">>;

person_verb_having_thing_complement_inner(70) -> <<"reinvest in">>;
person_verb_having_thing_complement_inner(71) -> <<"potentiate">>;
person_verb_having_thing_complement_inner(72) -> <<"front-face">>;
person_verb_having_thing_complement_inner(73) -> <<"co-develop">>;
person_verb_having_thing_complement_inner(74) -> <<"take control of">>;
person_verb_having_thing_complement_inner(75) -> <<"robustify">>;
person_verb_having_thing_complement_inner(76) -> <<"harness">>;
person_verb_having_thing_complement_inner(77) -> <<"activate">>;
person_verb_having_thing_complement_inner(78) -> <<"showcase">>;
person_verb_having_thing_complement_inner(79) -> <<"cherry-pick">>;

person_verb_having_thing_complement_inner(80) -> <<"digitize">>;
person_verb_having_thing_complement_inner(81) -> <<"re-invent">>;
person_verb_having_thing_complement_inner(82) -> <<"springboard">>;
person_verb_having_thing_complement_inner(83) -> <<"solutionize">>;
person_verb_having_thing_complement_inner(84) -> <<"re-content">>;
person_verb_having_thing_complement_inner(85) -> <<"commoditize">>;
person_verb_having_thing_complement_inner(86) -> <<"be eager for">>;
person_verb_having_thing_complement_inner(87) -> <<"productize">>;
person_verb_having_thing_complement_inner(88) -> <<"repurpose">>;
person_verb_having_thing_complement_inner(89) -> <<"reenergize">>;

person_verb_having_thing_complement_inner(90) -> <<"co-specify">>;
person_verb_having_thing_complement_inner(91) -> <<"codify">>;
person_verb_having_thing_complement_inner(92) -> <<"cross-pollinate">>;
person_verb_having_thing_complement_inner(93) -> <<"ignite">>;
person_verb_having_thing_complement_inner(94) -> <<"transgenerate">>;
person_verb_having_thing_complement_inner(95) -> <<"orchestrate">>;
person_verb_having_thing_complement_inner(96) -> <<"envisioneer">>;
person_verb_having_thing_complement_inner(97) -> <<"reintermediate">>.


%% Something Bad is going to happen. Fortunately Supermarketman is there
%% with his secret weapon to clean the Evil thing and rescue the Business.
%% Well, at least there will be a meeting to begin a discussion about it.
person_verb_having_bad_thing_complement(P) ->
    V = person_verb_having_bad_thing_complement_inner(rand:uniform(9)),
    build_plural_verb(V, P).

person_verb_having_bad_thing_complement_inner(1) -> <<"address">>;
person_verb_having_bad_thing_complement_inner(2) -> <<"identify">>;
person_verb_having_bad_thing_complement_inner(3) -> <<"avoid">>;
person_verb_having_bad_thing_complement_inner(4) -> <<"mitigate">>;
person_verb_having_bad_thing_complement_inner(5) -> <<"minimize">>;
person_verb_having_bad_thing_complement_inner(6) -> <<"overcome">>;
person_verb_having_bad_thing_complement_inner(7) -> <<"tackle">>;
person_verb_having_bad_thing_complement_inner(8) -> <<"reduce">>;
person_verb_having_bad_thing_complement_inner(9) -> <<"alleviate">>.


%% (thing) verb (thing)
thing_verb_having_thing_complement(P) ->
    V = thing_verb_having_thing_complement_inner(rand:uniform(43)),
    build_plural_verb(V, P).

thing_verb_having_thing_complement_inner(1)  -> <<"streamline">>;
thing_verb_having_thing_complement_inner(2)  -> <<"interact with">>;
thing_verb_having_thing_complement_inner(3)  -> <<"boost">>;
thing_verb_having_thing_complement_inner(4)  -> <<"generate">>;
thing_verb_having_thing_complement_inner(5)  -> <<"impact">>;
thing_verb_having_thing_complement_inner(6)  -> <<"enhance">>;
thing_verb_having_thing_complement_inner(7)  -> <<"leverage">>;
thing_verb_having_thing_complement_inner(8)  -> <<"synergize">>;
thing_verb_having_thing_complement_inner(9)  -> <<"generate">>;

thing_verb_having_thing_complement_inner(10) -> <<"empower">>;
thing_verb_having_thing_complement_inner(11) -> <<"enable">>;
thing_verb_having_thing_complement_inner(12) -> <<"prioritize">>;
thing_verb_having_thing_complement_inner(13) -> <<"transfer">>;
thing_verb_having_thing_complement_inner(14) -> <<"drive">>;
thing_verb_having_thing_complement_inner(15) -> <<"result in">>;
thing_verb_having_thing_complement_inner(16) -> <<"promote">>;
thing_verb_having_thing_complement_inner(17) -> <<"influence">>;
thing_verb_having_thing_complement_inner(18) -> <<"facilitate">>;
thing_verb_having_thing_complement_inner(19) -> <<"aggregate">>;

thing_verb_having_thing_complement_inner(20) -> <<"architect">>;
thing_verb_having_thing_complement_inner(21) -> <<"cultivate">>;
thing_verb_having_thing_complement_inner(22) -> <<"engage">>;
thing_verb_having_thing_complement_inner(23) -> <<"structure">>;
thing_verb_having_thing_complement_inner(24) -> <<"standardize">>;
thing_verb_having_thing_complement_inner(25) -> <<"accelerate">>;
thing_verb_having_thing_complement_inner(26) -> <<"deepen">>;
thing_verb_having_thing_complement_inner(27) -> <<"strengthen">>;
thing_verb_having_thing_complement_inner(28) -> <<"enforce">>;
thing_verb_having_thing_complement_inner(29) -> <<"foster">>;

thing_verb_having_thing_complement_inner(30) -> <<"turbocharge">>;
thing_verb_having_thing_complement_inner(31) -> <<"granularize">>;
thing_verb_having_thing_complement_inner(32) -> <<"operationalize">>;
thing_verb_having_thing_complement_inner(33) -> <<"reconceptualize">>;
thing_verb_having_thing_complement_inner(34) -> <<"iterate">>;
thing_verb_having_thing_complement_inner(35) -> <<"revolutionise">>;
thing_verb_having_thing_complement_inner(36) -> <<"digitize">>;
thing_verb_having_thing_complement_inner(37) -> <<"solutionize">>;
thing_verb_having_thing_complement_inner(38) -> <<"lead to">>;
thing_verb_having_thing_complement_inner(39) -> <<"reenergize">>;

thing_verb_having_thing_complement_inner(40) -> <<"restructure">>;
thing_verb_having_thing_complement_inner(41) -> <<"cross-pollinate">>;
thing_verb_having_thing_complement_inner(42) -> <<"ignite">>;
thing_verb_having_thing_complement_inner(43) -> <<"transgenerate">>.


%% (thing) verb (person)
thing_verb_having_person_complement(P) ->
    V = thing_verb_having_person_complement_inner(rand:uniform(16)),
    build_plural_verb(V, P).

thing_verb_having_person_complement_inner(1) -> <<"motivate">>;
thing_verb_having_person_complement_inner(2) -> <<"target">>;
thing_verb_having_person_complement_inner(3) -> <<"enable">>;
thing_verb_having_person_complement_inner(4) -> <<"drive">>;
thing_verb_having_person_complement_inner(5) -> <<"synergize">>;
thing_verb_having_person_complement_inner(6) -> <<"empower">>;
thing_verb_having_person_complement_inner(7) -> <<"prioritize">>;
thing_verb_having_person_complement_inner(8) -> <<"incentivise">>;
thing_verb_having_person_complement_inner(9) -> <<"inspire">>;

thing_verb_having_person_complement_inner(10) -> <<"transfer">>;
thing_verb_having_person_complement_inner(11) -> <<"promote">>;
thing_verb_having_person_complement_inner(12) -> <<"influence">>;
thing_verb_having_person_complement_inner(13) -> <<"strengthen">>;
thing_verb_having_person_complement_inner(14) -> <<"energize">>;
thing_verb_having_person_complement_inner(15) -> <<"invigorate">>;
thing_verb_having_person_complement_inner(16) -> <<"reenergize">>.


%% This function produces an eventual definite complement
%% after the verb, or no complement at all.
person_verb_and_definite_ending(P, Infinitive) ->
    Inner = person_verb_and_definite_ending_inner(rand:uniform(106)),
    %% be /= are
    case Infinitive of
	true ->
	    Inner;
	false ->
	    build_plural_verb(Inner, P)
    end.

person_verb_and_definite_ending_inner(1)   -> <<"streamline the process">>;
person_verb_and_definite_ending_inner(2)   -> <<"address the overarching issues">>;
person_verb_and_definite_ending_inner(3)   -> <<"benchmark the portfolio">>;
person_verb_and_definite_ending_inner(4)   -> <<"manage the cycle">>;
person_verb_and_definite_ending_inner(5)   ->
    <<"figure out where we come from, where we are going to">>;
person_verb_and_definite_ending_inner(6)   -> <<"maximize the value">>;
person_verb_and_definite_ending_inner(7)   -> <<"execute the strategy">>;
person_verb_and_definite_ending_inner(8)   -> <<"think out of the box">>;
person_verb_and_definite_ending_inner(9)   -> <<"think differently">>;

person_verb_and_definite_ending_inner(10)  -> <<"think across the full value chain">>;
person_verb_and_definite_ending_inner(11)  -> <<"loop back">>;
person_verb_and_definite_ending_inner(12)  -> <<"conversate">>;
person_verb_and_definite_ending_inner(13)  -> <<"go forward together">>;
person_verb_and_definite_ending_inner(14)  -> <<"achieve efficiencies">>;
person_verb_and_definite_ending_inner(15)  -> <<"deliver">>;
person_verb_and_definite_ending_inner(16)  -> <<"stay in the mix">>;
person_verb_and_definite_ending_inner(17)  -> <<"stay in the zone">>;
person_verb_and_definite_ending_inner(18)  -> <<"evolve">>;
person_verb_and_definite_ending_inner(19)  -> <<"exceed expectations">>;

person_verb_and_definite_ending_inner(20)  -> <<"develop the plan">>;
person_verb_and_definite_ending_inner(21)  -> <<"develop the blue print for execution">>;
person_verb_and_definite_ending_inner(22)  -> <<"grow and diversify">>;
person_verb_and_definite_ending_inner(23)  -> <<"fuel changes">>;
person_verb_and_definite_ending_inner(24)  -> <<"nurture talent">>;
person_verb_and_definite_ending_inner(25)  -> <<"cultivate talent">>;
person_verb_and_definite_ending_inner(26)  -> <<"make it possible">>;
person_verb_and_definite_ending_inner(27)  -> <<"manage the portfolio">>;
person_verb_and_definite_ending_inner(28)  -> <<"align resources">>;
person_verb_and_definite_ending_inner(29)  -> <<"drive the business forward">>;

person_verb_and_definite_ending_inner(30)  -> <<"make things happen">>;
person_verb_and_definite_ending_inner(31)  -> <<"stay ahead">>;
person_verb_and_definite_ending_inner(32)  -> <<"outperform peers">>;
person_verb_and_definite_ending_inner(33)  -> <<"surge ahead">>;
person_verb_and_definite_ending_inner(34)  -> <<"manage the downside">>;
person_verb_and_definite_ending_inner(35)  -> <<"stay in the wings">>;
person_verb_and_definite_ending_inner(36)  -> <<"come to a landing">>;
person_verb_and_definite_ending_inner(37)  -> <<"shoot it over">>;
person_verb_and_definite_ending_inner(38)  -> <<"move the needle">>;
person_verb_and_definite_ending_inner(39)  -> <<"connect the dots">>;

person_verb_and_definite_ending_inner(40)  -> <<"connect the dots to the end game">>;
person_verb_and_definite_ending_inner(41)  -> <<"reset the benchmark">>;
person_verb_and_definite_ending_inner(42)  -> <<"take it offline">>;
person_verb_and_definite_ending_inner(43)  -> <<"peel the onion">>;
person_verb_and_definite_ending_inner(44)  -> <<"drill down">>;
person_verb_and_definite_ending_inner(45)  -> <<"get from here to here">>;
person_verb_and_definite_ending_inner(46)  -> <<"do things differently">>;
person_verb_and_definite_ending_inner(47)  -> <<"stretch the status quo">>;
person_verb_and_definite_ending_inner(48)  -> <<"challenge the status quo">>;
person_verb_and_definite_ending_inner(49)  -> <<"challenge established ideas">>;

person_verb_and_definite_ending_inner(50)  -> <<"increase customer satisfaction">>;
person_verb_and_definite_ending_inner(51)  -> <<"enable customer interaction">>;
person_verb_and_definite_ending_inner(52)  -> <<"manage the balance">>;
person_verb_and_definite_ending_inner(53)  -> <<"turn every stone">>;
person_verb_and_definite_ending_inner(54)  -> <<"drive revenue">>;
person_verb_and_definite_ending_inner(55)  -> <<"rise to the challenge">>;
person_verb_and_definite_ending_inner(56)  -> <<"keep it on the radar">>;
person_verb_and_definite_ending_inner(57)  -> <<"stay on trend">>;
person_verb_and_definite_ending_inner(58)  -> <<"hunt the business down">>;
person_verb_and_definite_ending_inner(59)  -> <<"push the envelope to the tilt">>;

person_verb_and_definite_ending_inner(60)  -> <<"execute on priorities">>;
person_verb_and_definite_ending_inner(61)  -> <<"stand out from the crowd">>;
person_verb_and_definite_ending_inner(62)  -> <<"make the abstract concrete">>;
person_verb_and_definite_ending_inner(63)  -> <<"manage the mix">>;
person_verb_and_definite_ending_inner(64)  -> <<"grow">>;
person_verb_and_definite_ending_inner(65)  -> <<"accelerate the strategy">>;
person_verb_and_definite_ending_inner(66)  -> <<"enhance the strength">>;
person_verb_and_definite_ending_inner(67)  -> <<"create long-term value">>;
person_verb_and_definite_ending_inner(68)  -> <<"meet the challenges">>;
person_verb_and_definite_ending_inner(69)  -> <<"move the progress forward">>;

person_verb_and_definite_ending_inner(70)  -> <<"do the right projects">>;
person_verb_and_definite_ending_inner(71)  -> <<"do the projects right">>;
person_verb_and_definite_ending_inner(72)  -> <<"do more with less">>;
person_verb_and_definite_ending_inner(73)  -> <<"build winning teams">>;
person_verb_and_definite_ending_inner(74)  -> <<"deliver on commitments">>;
person_verb_and_definite_ending_inner(75)  -> <<"execute">>;
person_verb_and_definite_ending_inner(76)  -> <<"deliver">>;
person_verb_and_definite_ending_inner(77)  -> <<"see around the corner">>;
person_verb_and_definite_ending_inner(78)  -> <<"meet the surge">>;
person_verb_and_definite_ending_inner(79)  -> <<"celebrate the success">>;

person_verb_and_definite_ending_inner(80)  -> <<"circle back">>;
person_verb_and_definite_ending_inner(81)  -> <<"action forward">>;
person_verb_and_definite_ending_inner(82)  -> <<"move forward">>;
person_verb_and_definite_ending_inner(83)  -> <<"take control">>;
person_verb_and_definite_ending_inner(84)  -> <<"be cautiously optimistic">>;
person_verb_and_definite_ending_inner(85)  -> <<"be committed">>;
person_verb_and_definite_ending_inner(86)  -> <<"evolve our culture">>;
person_verb_and_definite_ending_inner(87)  ->
    <<"leverage the benefits of our differentiation">>;
person_verb_and_definite_ending_inner(88)  -> <<"stretch our data bucket">>;
person_verb_and_definite_ending_inner(89)  -> <<"leapfrog the competition">>;

person_verb_and_definite_ending_inner(90)  -> <<"take the elevator beyond the top floor">>;
person_verb_and_definite_ending_inner(91)  -> <<"stick to the knitting">>;
person_verb_and_definite_ending_inner(92)  -> <<"bring our vision to reality">>;
person_verb_and_definite_ending_inner(93)  ->
    T1 = thing_atom(false),
    T2 = thing_atom(false),
    T3 = thing_atom(false),
    <<"create an environment where ",
      T1/binary,", ",
      T2/binary," and ",
      T3/binary," can thrive">>;
person_verb_and_definite_ending_inner(94)  -> <<"seize opportunities">>;
person_verb_and_definite_ending_inner(95)  -> <<"create momentum">>;
person_verb_and_definite_ending_inner(96)  -> <<"generate company momentum">>;
person_verb_and_definite_ending_inner(97)  -> <<"pursue new opportunities">>;
person_verb_and_definite_ending_inner(98)  -> <<"increase adherence">>;
person_verb_and_definite_ending_inner(99)  -> <<"focus on the right things">>;

person_verb_and_definite_ending_inner(100) -> <<"open the kimono">>;
person_verb_and_definite_ending_inner(101) -> <<"give 110%">>;
person_verb_and_definite_ending_inner(102) -> <<"take it to the next level">>;
person_verb_and_definite_ending_inner(103) -> <<"boil the ocean">>;
person_verb_and_definite_ending_inner(104) -> <<"close the loop">>;
person_verb_and_definite_ending_inner(105) -> <<"create value">>;
person_verb_and_definite_ending_inner(106) -> <<"disrupt the status quo">>.


%% NB: this function produces an eventual definite complement
%% after the verb, or no complement at all.
thing_verb_and_definite_ending(P) ->
    Inner = thing_verb_and_definite_ending_inner(rand:uniform(2)),
    build_plural_verb(Inner ,P).

thing_verb_and_definite_ending_inner(1) -> <<"add value">>;
thing_verb_and_definite_ending_inner(2) -> <<"deliver maximum impact">>.


%% Verb + Ending. Ending is a Complement or something else
thing_verb_and_ending(P) ->
    C = random_plural(),
    thing_verb_and_ending(rand:uniform(102), P, C).
%%
thing_verb_and_ending(R, P, C)
  when 1 =< R, R =< 55 ->
    T1 = thing_verb_having_thing_complement(P),
    T2 = add_random_article(thing(C), C),
    <<T1/binary," ",T2/binary>>;
thing_verb_and_ending(R, P, C)
  when 56 =< R, R =< 100 ->
    T1 = thing_verb_having_person_complement(P),
    P1 = person(C),
    <<T1/binary," the ",P1/binary>>;
thing_verb_and_ending(R, P, _C)
  when 101 =< R, R =< 102 ->
    T = thing_verb_and_definite_ending(P),
    <<T/binary>>.


person_verb_and_ending(P, Infinitive) ->
    C = random_plural(),
    person_verb_and_ending(rand:uniform(95), P, C, Infinitive).
%%
person_verb_and_ending(R, P, _C, I)
  when 1 =< R, R =< 10 ->
    P1 = person_verb_and_definite_ending(P, I),
    <<P1/binary>>;
%% Fight-the-Evil situation
person_verb_and_ending(R, P, _C, _I)
  when 11 =< R, R =< 15 ->
    P1 = person_verb_having_bad_thing_complement(P),
    T1 = add_random_article(bad_things(), true),
    <<P1/binary," ",T1/binary>>;
person_verb_and_ending(R, P, C, I)
  when 16 =< R, R =< 95 ->
    P1 = person_verb_having_thing_complement(P, I),
    T1 = add_random_article(thing(C), C),
    <<P1/binary," ",T1/binary>>.


% "We need to..." and similar forward-looking constructions
faukon() ->
    faukon(rand:uniform(14)).
%%
faukon(1) -> <<"we need to">>;
faukon(2) -> <<"we've got to">>;
faukon(3) -> <<"the reporting unit should">>;
faukon(4) -> <<"controlling should">>;
faukon(5) ->
    M = matrix_or_so(),
    <<"we must activate the ",M/binary," to">>;
faukon(6) -> <<"pursuing this route will enable us to">>;
faukon(7) -> <<"we will go the extra mile to">>;
faukon(8) -> <<"we are working hard to">>;
faukon(9) -> <<"we continue to work tirelessly and diligently to">>;
faukon(10) -> <<"we will execute to">>;
faukon(11) -> <<"we will sharpen our business models to">>;
faukon(12) -> <<"to continue our growth, we must">>;
faukon(13) -> <<"we are going to">>;
faukon(14) -> <<"we look forward to working together to">>.


% Plural: trick to get the infinitive, unless explicitely built as infinitive.
person_infinitive_verb_and_ending() ->
    person_verb_and_ending(true, true).


proposition() ->
    C = random_plural(),
    proposition(rand:uniform(109), C).

%% "We need to..."
proposition(R, _C) when 1 =< R, R =< 5 ->
    F = faukon(),
    P1 = person_infinitive_verb_and_ending(), % infinitive written same as present plural
    A1 = eventual_postfixed_adverb(),
    <<F/binary," ",P1/binary,A1/binary>>;
%% ** PERSON...
proposition(R, C) when 6 =< R, R =< 50 ->
    P1 = person(C),
    A1 = eventual_adverb(),
    P2 = person_verb_and_ending(C, false),
    A2 = eventual_postfixed_adverb(),
    <<"the ",P1/binary," ",
      A1/binary,P2/binary,A2/binary>>;
%% ** THING...
proposition(R, C) when 51 =< R, R =< 92 ->
    T1 = add_random_article(thing(C), C),
    A1 = eventual_adverb(),
    T2 = thing_verb_and_ending(C),
    A2 = eventual_postfixed_adverb(),
    <<T1/binary," ",
    A1/binary,T2/binary,A2/binary>>;
%% ** thing and thing ...
proposition(R, _C) when 93 =< R, R =< 97 ->
    T1 = thing_atom(false),
    T2 = thing_atom(false),
    A1 = eventual_adverb(),
    T3 = thing_verb_and_ending(true),
    A2 = eventual_postfixed_adverb(),
    <<T1/binary," and ",
      T2/binary," ",
      A1/binary,T3/binary,A2/binary>>;
%% ** thing, thing and thing ...
proposition(R, _C) when 98 =< R, R =< 100 ->
    T1 = thing_atom(false),
    T2 = thing_atom(false),
    T3 = thing_atom(false),
    A1 = eventual_adverb(),
    T4 = thing_verb_and_ending(true),
    A2 = eventual_postfixed_adverb(),
    <<T1/binary,", ",
      T2/binary," and ",
      T3/binary," ",
      A1/binary,T4/binary,A2/binary>>;
proposition(101, _C) ->
    G1 = growth_atom(),
    G2 = add_indefinite_article(growth(), false),
    <<"there can be no ", G1/binary,
      " until we can achieve ",G2/binary>>;
proposition(102, _C) ->
    T1 = thing(true),
    P1 = person_infinitive_verb_and_ending(),
    <<T1/binary,"  challenge us to ",P1/binary>>;
proposition(103, C) ->
    T1 = thing(false),
    T2 = thing(C),
    <<T1/binary," is all about ",T2/binary>>;
proposition(104, C) ->
    T1 = thing_atom(C),
    <<"there is no alternative to ",T1/binary>>;
proposition(105, _C) ->
    T1 = thing_atom(false),
    T2 = thing_atom(false),
    <<"the key to ",T1/binary," is ",T2/binary>>;
proposition(106, C) ->
    T1 = thing(C),
    <<"opting out of ",T1/binary," is not a choice">>;
proposition(107, _C) ->
    G1 = add_indefinite_article(growth(), false),
    G2 = add_indefinite_article(growth(), false),
    <<G1/binary," goes hand-in-hand with ",G2/binary>>;
proposition(108, C) ->
    P1 = person(C),
    P2 = person_infinitive_verb_and_ending(),
    <<"the ",P1/binary,
    " will be well equipped to ",P2/binary>>;
proposition(109, _C) ->
    T1 = thing_atom(false),
    <<T1/binary," is a matter of speed of action">>.


articulated_propositions() ->
    articulated_propositions(rand:uniform(411)).
%%
articulated_propositions(R) when 1 =< R, R =< 270 ->
    proposition();
articulated_propositions(R) when 271 =< R, R =< 280 ->
    P1 = proposition(),
    P2 = proposition(),
    <<P1/binary,"; this is why ",P2/binary>>;
articulated_propositions(R) when 281 =< R, R =< 290 ->
    P1 = proposition(),
    P2 = proposition(),
    <<P1/binary,"; nevertheless ",P2/binary>>;
articulated_propositions(R) when 291 =< R, R =< 300 ->
    P1 = proposition(),
    P2 = proposition(),
    <<P1/binary,", whereas ",P2/binary>>;
articulated_propositions(R) when 311 =< R, R =< 350 ->
    P1 = proposition(),
    P2 = proposition(),
    <<P1/binary,", while ",P2/binary>>;
articulated_propositions(R) when 351 =< R, R =< 360 ->
    P1 = proposition(),
    P2 = proposition(),
    <<P1/binary,". In the same time, ",P2/binary>>;
articulated_propositions(R) when 361 =< R, R =< 370 ->
    P1 = proposition(),
    P2 = proposition(),
    <<P1/binary,". As a result, ",P2/binary>>;
articulated_propositions(R) when 371 =< R, R =< 380 ->
    P1 = proposition(),
    P2 = proposition(),
    <<P1/binary,", whilst ",P2/binary>>;
%% Lower probability constructs
articulated_propositions(R) when 301 =< R, R =< 303 ->
    P1 = proposition(),
    <<"our gut-feeling is that ",P1/binary>>;
articulated_propositions(R) when 304 =< R, R =< 306 ->
    P1 = person_infinitive_verb_and_ending(),
    P2 = person_infinitive_verb_and_ending(),
    <<"the point is not merely to ",P1/binary,
      ". The point is to ",P2/binary>>;
articulated_propositions(R) when 307 =< R, R =< 310 ->
    P = random_plural(),
    T1 = thing_atom(P),
    T2 = add_random_article(thing(P), P),
    <<"it's not about ",T1/binary,
    ". It's about ",T2/binary>>;
articulated_propositions(R) when 381 =< R, R =< 383 ->
    P1 = person_infinitive_verb_and_ending(),
    P2 = person_infinitive_verb_and_ending(),
    <<"our challenge is not to ",P1/binary,
      ". Our challenge is to ",P2/binary>>;
articulated_propositions(R) when 384 =< R, R =< 386 ->
    P1 = proposition(),
    <<"going forward, ",P1/binary>>;
articulated_propositions(R) when 387 =< R, R =< 389 ->
    P1 = proposition(),
    <<"actually, ",P1/binary>>;
articulated_propositions(R) when 390 =< R, R =< 392 ->
    P1 = proposition(),
    <<"in the future, ",P1/binary>>;
articulated_propositions(R) when 393 =< R, R =< 395 ->
    P1 = proposition(),
    <<"flat out, ",P1/binary>>;
articulated_propositions(R) when 396 =< R, R =< 398 ->
    P1 = proposition(),
    <<"first and foremost, ",P1/binary>>;
articulated_propositions(R) when 399 =< R, R =< 402 ->
    T1  = thing_atom(false),
    T2  = thing_atom(false),
    T3  = thing_atom(false),
    T4  = thing_atom(false),
    T5  = thing_atom(false),
    T6  = thing_atom(false),
    T7  = thing_atom(false),
    T8  = thing_atom(false),
    T9  = thing_atom(false),
    T10 = thing_atom(false),
    <<T1/binary,", ",
      T2/binary,", ",
      T3/binary,", ",
      T4/binary,", and ",
      T5/binary," - not ",
      T6/binary,", ",
      T7/binary,", ",
      T8/binary,", ",
      T9/binary,", and ",
      T10/binary>>;
articulated_propositions(403) ->
    P1 = proposition(),
    <<"in today's fast-changing world, ",P1/binary>>;
articulated_propositions(404) ->
    P1 = proposition(),
    <<"internally and externally, ",P1/binary>>;
articulated_propositions(405) ->
    P1 = proposition(),
    <<"our message is: ",P1/binary>>;
articulated_propositions(406) ->
    P1 = proposition(),
    <<"in a data-first world, ",P1/binary>>;
articulated_propositions(407) ->
    <<"the future awaits">>;
articulated_propositions(408) ->
    T1 = thing_atom(true),
    <<T1/binary," not only thrive on change, they initiate it">>;
articulated_propositions(409) ->
    P = random_plural(),
    T1 = thing_atom(P),
    T2 = thing_atom(false),
    <<"as the pace of ",T1/binary,
    " continues to accelerate, ",T2/binary,
    " has become a necessity">>;
articulated_propositions(410) ->
    T1 = thing_atom(false),
    T2 = thing_atom(false),
    T3 = thing_atom(false),
    T4 = thing_atom(false),
    P1 = person(true),
    <<T1/binary,", ",
      T2/binary,", ",
      T3/binary,", ",
      T4/binary, " - all are competing for the attention of ",
      P1/binary>>;
articulated_propositions(411) ->
    <<"success brings success">>.





%%%=========================================================================
%%%  English grammar tools
%%%=========================================================================

vowel(<<$a>>) -> true;
vowel(<<$e>>) -> true;
vowel(<<$i>>) -> true;
vowel(<<$o>>) -> true;
vowel(<<$u>>) -> true;
vowel(<<$y>>) -> true;
vowel(<<$A>>) -> true;
vowel(<<$E>>) -> true;
vowel(<<$I>>) -> true;
vowel(<<$O>>) -> true;
vowel(<<$U>>) -> true;
vowel(<<$Y>>) -> true;
vowel($a) -> true;
vowel($e) -> true;
vowel($i) -> true;
vowel($o) -> true;
vowel($u) -> true;
vowel($y) -> true;
vowel($A) -> true;
vowel($E) -> true;
vowel($I) -> true;
vowel($O) -> true;
vowel($U) -> true;
vowel($Y) -> true;
vowel(_) -> false.


make_eventual_plural(Word, false) ->
    Word;
make_eventual_plural(Word, true)
  when byte_size(Word) < 3 ->
    Word;
make_eventual_plural(Word, true) ->
    case abbr_index(Word) of
	nomatch ->
	    make_plural(Word);
	Pos ->
	    %% Example: Quality Management Systems (QMS)
	    {Front, Rest} = split_binary(Word, Pos),
	    P = make_plural(Front),
	    <<P/binary,Rest/binary>>
    end.

make_plural(<<"matrix">>) -> <<"matrices">>;
make_plural(<<"analysis">>) -> <<"analyses">>;
make_plural(S)
  when binary_part(S, byte_size(S) - 2, 2) =:= <<"gh">> ->
    <<S/binary,"s">>;
make_plural(S)
  when binary_part(S, byte_size(S) - 1, 1) =:= <<"s">>;
       binary_part(S, byte_size(S) - 1, 1) =:= <<"x">>;
       binary_part(S, byte_size(S) - 1, 1) =:= <<"z">>;
       binary_part(S, byte_size(S) - 1, 1) =:= <<"h">> ->
    <<S/binary,"es">>;
make_plural(S)
  when binary_part(S, byte_size(S) - 1, 1) =:= <<"y">> ->
    case vowel(binary_part(S, byte_size(S) - 2, 1)) of
	true ->
	    %% wAy -> wAys
	    <<S/binary,"s">>;
	false ->
	    %% fLy -> fLies
	    LastCharPos = byte_size(S) - 1,
	    Init = binary_part(S, 0, LastCharPos),
	    <<Init/binary,"ies">>
    end;
make_plural(S) ->
    <<S/binary,"s">>.


abbr_index(S) ->
    case binary:match(S, <<" (">>) of
	{Pos, _} ->
	    Pos;
	nomatch ->
	    nomatch
    end.

first_space(S) ->
    case binary:match(S, <<" ">>) of
	{Pos, _} ->
	    Pos;
	nomatch ->
	    nomatch
    end.

last_verb_char_pos(S) ->
    LastChar = byte_size(S) - 1,
    SpacePos = first_space(S),
    case SpacePos of
	nomatch ->
	    LastChar;
	Pos ->
	   Pos - 1
    end.

build_plural_verb(Verb0, Plural) ->
    LastCharPos = last_verb_char_pos(Verb0),
    Init        = binary_part(Verb0, 0, LastCharPos),
    Verb        = binary_part(Verb0, 0, LastCharPos + 1),
    C1          = binary_part(Verb0, LastCharPos, 1),
    C2          = binary_part(Verb0, LastCharPos - 1, 1),
    Tail        = binary_part(Verb0, LastCharPos + 1,
			      byte_size(Verb0) - LastCharPos - 1),
    build_plural_verb(Init, Verb, Tail, C1, C2, Plural).
%%
build_plural_verb(_Init, <<"be">>, Tail, _, _, false) ->
    <<"is",Tail/binary>>;
build_plural_verb(_Init, <<"be">>, Tail, _, _, true) ->
    <<"are",Tail/binary>>;
build_plural_verb(_Init, <<"have">>, Tail, _, _, false) ->
    <<"has",Tail/binary>>;
build_plural_verb(_Init, <<"have">> = V, Tail, _, _, true) ->
    <<V/binary,Tail/binary>>;
build_plural_verb(_Init, Verb, Tail, _, _, true) ->
    <<Verb/binary,Tail/binary>>;
build_plural_verb(_Init, Verb, Tail, C1, _, false)
  when C1 =:= <<"o">>; C1 =:= <<"s">>; C1 =:= <<"z">> ->
    %% echo -> echoes; do -> does
    <<Verb/binary,"es",Tail/binary>>;
build_plural_verb(_Init, Verb, Tail, <<"h">>, C2, false)
  when C2 =:= <<"c">>; C2 =:= <<"s">> ->
    %% catch -> catches; establish -> establishes
    <<Verb/binary,"es",Tail/binary>>;
build_plural_verb(_Init, Verb, Tail, <<"h">>, _C2, false) ->
    %% plough -> ploughs
    <<Verb/binary,"s",Tail/binary>>;
build_plural_verb(Init, Verb, Tail, <<"y">>, C2, false) ->
    case vowel(C2) of
	true ->
	    %% plOy -> plOys
	    <<Verb/binary,"s",Tail/binary>>;
	false ->
	    %% tRy -> tRies
	    <<Init/binary,"ies",Tail/binary>>
    end;
build_plural_verb(_Init, Verb, Tail, _C1, _C2, false) ->
    <<Verb/binary,"s",Tail/binary>>.


add_indefinite_article(Word, true) ->
    Word;
add_indefinite_article(<<H,_/binary>> = Word, false) ->
    case vowel(H) of
	true ->
	    <<"an ",Word/binary>>;
	false ->
	    <<"a ",Word/binary>>
    end.
