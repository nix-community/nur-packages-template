"use strict";
const { app, remote } = require("electron");
const AutoLaunch = require("auto-launch");
const { is } = require("./util");
const {store: settings} = require("./settings");

const _settings = {
  name: "Kuro",
  path: is.darwin
    ? (app || remote.app).getPath("exe").replace(/\.app\/Content.*/, ".app")
    : undefined,
  isHidden: true,
};

class Startup {
  constructor(settings) {
    this._launcher = new AutoLaunch(settings);
  }

  async _activate() {
    const enabled = await this._launcher.isEnabled();
    if (!enabled) {
      return this._launcher.enable();
    }
  }

  async _deactivate() {
    const enabled = await this._launcher.isEnabled();
    if (enabled) {
      return this._launcher.disable();
    }
  }

  autoLaunch() {
    if (settings.get("autoLaunch")) {
      this._activate();
    } else {
      this._deactivate();
    }
  }
}

module.exports = new Startup(_settings);
