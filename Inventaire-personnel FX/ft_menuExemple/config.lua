  -- @Date:   2017-06-11T12:15:17+02:00
  -- @Project: FiveM Tools
-- @Last modified time: 2017-06-11T18:02:32+02:00
  -- @License: GNU General Public License v3.0

  menu = {

    ft_menuOne = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "CATEGORIES",
      },

      buttons = {
        { text = "Animations", menu = "anim" },
        { text = "GPS", menu = "gps" },
        { text = "Telephone", callback = phoneMenu, close = true },
        { text = "Ma carte d'identite", menu = "carte" },
        { text = "Sauvegarder ma position", callback = Saver },
        { text = "Fermer le menu", close = true },
      },

    },

    anim = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "CATEGORIES",
      },

      buttons = {
		{ text = "Animations Humeur", menu = "humeur" },
		{ text = "Animations Salu", menu = "salu" },
		{ text = "Animations Sportives", menu = "sportives" },
		{ text = "Animations Festives", menu = "festives" },
		{ text = "Prendre une Pose", menu = "pose" },
		{ text = "Autres", menu = "autre" },
		{ text = "Retour", back = true },
      },

    },
	
    humeur = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "Animations Humeur",
      },

      buttons = {
      	{ text = "Applaudir", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_CHEERING" } },
		{ text = "Calme toi", callback = animsAction, data = { lib = "gestures@m@standing@casual", anim = "gesture_easy_now" } },
		{ text = "Damm", callback = animsAction, data = { lib = "gestures@m@standing@casual", anim = "gesture_damn" } },
        { text = "Doigt d'honneur", callback = animsAction, data = { lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter" } },
		{ text = "Super !", callback = animsAction, data = { lib = "mp_action", anim = "thanks_male_06" } },
		{ text = "Enlacer", callback = animsAction, data = { lib = "mp_ped_interaction", anim = "kisses_guy_a" } },
		{ text = "Signe de la main", callback = animsAction, data = { lib = "friends@frj@ig_1", anim = "wave_e" } },
		{ text = "Retour", back = true },
      },

    },		
	
    salu = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "Animations Salue",
      },

      buttons = {
      	{ text = "Serrer la main", callback = animsAction, data = { lib = "mp_common", anim = "givetake1_a" } },
		{ text = "Dire bonjour", callback = animsAction, data = { lib = "gestures@m@standing@casual", anim = "gesture_hello" } },
		{ text = "Tappes moi en 5", callback = animsAction, data = { lib = "mp_ped_interaction", anim = "highfive_guy_a" } },
        { text = "Salut militaire", callback = animsAction, data = { lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute" } },
		{ text = "Retour", back = true },
      },

    },	

    sportives = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "Animations Sportives",
      },

      buttons = {
		{ text = "Faire du Yoga", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_YOGA" } },
		{ text = "Jogging", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_JOG_STANDING" } },
        { text = "Faire des pompes", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_PUSH_UPS" } },
		{ text = "Retour", back = true },
      },

    },		
	
    festives = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "Animations Festives",
      },

      buttons = {
		{ text = "Boire une biere", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_DRINKING" } },
		{ text = "Jouer de la musique", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_MUSICIAN" } },
		{ text = "Retour", back = true },
      },

    },				

    autre = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "Animations Festives",
      },

      buttons = {
      	{ text = "Oui", callback = animsAction, data = {  lib = "gestures@m@standing@casual", anim = "gesture_pleased" } },
		{ text = "Non", callback = animsAction, data = { lib = "gestures@m@standing@casual", anim = "gesture_head_no" } },
		{ text = "Prendre des notes", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_CLIPBOARD" } },
        { text = "Doigt d'honneur", callback = animsActionScenario, data = { anim = "mp_player_int_finger_01_enter" } },
		{ text = "Fumer une clope", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_SMOKING" } },
		{ text = "Portable", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_STAND_MOBILE" } },
		{ text = "Retour", back = true },
      },

    },	

    pose = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "Animations Festives",
      },

      buttons = {
		{ text = "Accouder au comptoir", callback = animsActionScenario, data = { anim = "PROP_HUMAN_BUM_SHOPPING_CART" } },
		{ text = "Assis au sol", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_PICNIC" } },
	    { text = "S'adosser", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_LEANING" } },
		{ text = "Sur le ventre", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_SUNBATHE" } },
		{ text = "Sur le dos", callback = animsActionScenario, data = { anim = "WORLD_HUMAN_SUNBATHE_BACK" } },
		{ text = "Retour", back = true },
      },

    },		
	
    gps = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "DESTITATIONS",
      },

      buttons = {
        { text = "Pole Emploi", callback = pole },
        { text = "Concessionnaire", callback = concepoint },
        { text = "Commissariat", callback = comico },
        { text = "Hopital", callback = hopi },
        { text = "Suprimer le point", callback = supr },
		{ text = "Retour", back = true },
      },

    },

    carte = {

      settings = {
        title = "Menu Personnel",
        menuTitle = "CARTE D'IDENTITE",
      },

      buttons = {
        { text = "Voir ma carte di'dentité", callback = carte },
		{ text = "Retour", back = true },
      },

    },

      ft_menuRigthTop = {

          settings = {
            title = "title",
            menuTitle = "Right top menu",
            top = true,
          },

          buttons = {
            { text = "Back menu", back = true },
          },

      },

      ft_menuCenterCenter = {

          settings = {
            title = "title",
            menuTitle = "Center Center menu",
            center = true,
          },

          buttons = {
            { text = "Back menu", back = true },
          },

      },

      ft_menuCenterTop = {

          settings = {
            title = "title",
            menuTitle = "Center Top menu",
            center = true,
            top = true,
          },

          buttons = {
            { text = "Back menu", back = true },
          },

      },

  }
