::  whitelist.hoon
::
/-  *whitelist
/+  default-agent, dbug
  |%
  +$  versioned-state
    $%  state-0
    ==
  +$  state-0  [%0 whitemap=(map ship whitelist)]
  +$  whitelist  (set @t)
  +$  card  card:agent:gall

++  whitelist-to-json
  |=  whitemap=(map ship whitelist)
  ^-  json
  %-  pairs:enjs:format
  %+  turn  ~(tap by whitemap)
  |=  [=ship whitelist=whitelist]
  :-  (scot %p ship)
  %-  frond:enjs:format
  :-  %domains
  a+(turn ~(tap in whitelist) |=(d=@t s+d))
--

%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /pals %agent [our.bowl %pals] %watch /targets]~

++  on-save
  ^-  vase
  !>(state)

++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  :_  this(state !<(state-0 old-state))
  [%pass /pals %agent [our.bowl %pals] %watch /targets]~

++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%x %whitelist ~]
    =/  our-whitelist  (~(get by whitemap.state) our.bowl)
    :_  this
    [%give %fact ~ %whitelist-update !>(our-whitelist)]~
  ==

++  on-leave  on-leave:def

++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %whitelist-action
    =/  action  !<(action vase)
    ?-    -.action
        %add
      =/  our-whitelist  (~(get by whitemap.state) our.bowl)
      =/  updated-whitelist  ?~(our-whitelist *(set @t) u.our-whitelist)
      =/  new-whitelist  (~(put in updated-whitelist) domain.action)
      =/  new-state  this(whitemap.state (~(put by whitemap.state) our.bowl new-whitelist))
      :_  new-state
      [%give %fact ~[/x/whitelist] %whitelist-update !>(new-whitelist)]~
    ::
        %remove
      =/  our-whitelist  (~(get by whitemap.state) our.bowl)
      ?~  our-whitelist  `this
      =/  new-whitelist  (~(del in u.our-whitelist) domain.action)
      =/  new-state  this(whitemap.state (~(put by whitemap.state) our.bowl new-whitelist))
      :_  new-state
      [%give %fact ~[/x/whitelist] %whitelist-update !>(new-whitelist)]~
    ==
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%pals ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  pals  !<((set ship) q.cage.sign)
      =/  cards  %+  turn  ~(tap in pals)
        |=  =ship
        [%pass /whitelist/(scot %p ship) %agent [ship %whitelist] %watch /x/whitelist]
      [cards this]
    ==
      [%whitelist @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  ship  (slav %p i.t.wire)
      =/  whitelist  !<((set @t) q.cage.sign)
      `this(whitemap.state (~(put by whitemap.state) ship whitelist))
    ==
  ==
::
++  on-peek
|=  =path
^-  (unit (unit cage))
?+    path  (on-peek:def path)
    [%x %whitemap ~]
  ``noun+!>(whitemap.state)
    [%x %whitelist ~]
  ``json+!>((whitelist-to-json whitemap.state))
    [%x %pals ~]
  =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/targets/noun)
  ``json+!>(`json`[%a (turn ~(tap in pals) |=(p=ship [%s (scot %p p)]))])
==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--