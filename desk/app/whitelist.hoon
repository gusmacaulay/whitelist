::  whitelist.hoon
::
/-  *whitelist
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 whitelist=(map ship (set @t))]
+$  card  card:agent:gall

++  whitelist-to-json
  |=  whitelist-map=(map ship (set @t))
  ^-  json
  %-  pairs:enjs:format
  %+  turn  ~(tap by whitelist-map)
  |=  [=ship domains=(set @t)]
  :-  (scot %p ship)
  %-  frond:enjs:format
  :-  %domains
  a+(turn ~(tap in domains) |=(d=@t s+d))
--

%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  (quip card _this)
  `this(state [%0 (~(put by *(map ship (set @t))) our.bowl *(set @t))])
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==::
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %whitelist-action
    =/  action  !<($%(action) vase)
    ?-    -.action
        %add
      =/  ship-whitelist  (~(get by whitelist.state) ship.action)
      =/  updated-whitelist  ?~(ship-whitelist (set @t) u.ship-whitelist)
      =/  new-whitelist  (~(put in updated-whitelist) domain.action)
      `this(whitelist.state (~(put by whitelist.state) ship.action new-whitelist))
      ::
        %remove
      =/  ship-whitelist  (~(get by whitelist.state) ship.action)
      ?~  ship-whitelist  `this
      =/  new-whitelist  (~(del in u.ship-whitelist) domain.action)
      `this(whitelist.state (~(put by whitelist.state) ship.action new-whitelist))
    ==
  ==
::  
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %whitelist ~]
    ``json+!>((whitelist-to-json whitelist.state))
      [%x %pals ~]
    =/  pals  .^((set ship) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/targets/noun)
    ``json+!>(`json`[%a (turn ~(tap in pals) |=(p=ship [%s (scot %p p)]))])
  ==
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--