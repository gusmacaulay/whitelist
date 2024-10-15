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
  `this(state [%0 (~(put by *(map ship whitelist)) our.bowl *(set @t))])

++  on-save
  ^-  vase
  !>(state)

++  on-load  on-load:def
  ::|=  old-state=vase
  ::^-  (quip card _this)
  ::=/  old  !<(versioned-state old-state)
  ::?-  -.old
  ::  %0  `this(state old)
  ::==
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
      `this(whitemap.state (~(put by whitemap.state) our.bowl new-whitelist))
    ::
        %remove
      =/  our-whitelist  (~(get by whitemap.state) our.bowl)
      ?~  our-whitelist  `this
      =/  new-whitelist  (~(del in u.our-whitelist) domain.action)
      `this(whitemap.state (~(put by whitemap.state) our.bowl new-whitelist))
    ::
        %import
      =*  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/targets/noun)
      =/  cards  %+  turn  ~(tap in pals)
        |=  =ship
        [%watch /whitelist %agent ship /x/whitelist]
      [cards this]
    ==
  ==
::
++  on-watch
  |=  [=ship =path]
  ^-  (quip card _this)
  ?+    path  (on-watch:def ship path)
      [%x %whitelist ~]
    ~&  (slag "Subscribed to whitelist of ship: " (scot %p ship))
    `this
  ==
::
++  on-leave
  |=  [=ship =path]
  ^-  (quip card _this)
  ?+    path  (on-leave:def ship path)
      [%x %whitelist ~]
    ~&  (slag "Unsubscribed from whitelist of ship: " (scot %p ship))
    `this
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
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%whitelist ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  whitelist  !<((map ship (set @t)) q.cage.sign)
      =/  new-whitemap  (~(uni by whitemap.state) whitelist)
      `this(whitemap.state new-whitemap)
    ==
  ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--