/* Window.vala  A simple display.
 * Copyright (C) 2014  Adrien Plazas
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 */

using Retro;
using Flicky;

using Gtk;

public class Window : Gtk.Window {
	private Gtk.HeaderBar header;
	private KeyboardBox kb_box;
	private Gtk.Image game_screen;
	
	private Gtk.Button open_core_button;
	private Gtk.Button open_game_button;
	private Gtk.Button start_button;
	private Gtk.Button pause_button;
	private Gtk.Button stop_button;
	private Gtk.Button properties_button;
	
	private AudioDevice audio_dev;
	
	private Engine engine;
	private Runner runner;
	
	public Window () {
		engine = null;
		
		header = new Gtk.HeaderBar ();
		kb_box = new KeyboardBox ();
		game_screen = new Gtk.Image ();
		
		open_core_button = new Gtk.Button.from_icon_name ("document-open-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		open_game_button = new Gtk.Button.from_icon_name ("document-open-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		pause_button = new Gtk.Button.from_icon_name ("media-playback-pause-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		stop_button = new Gtk.Button.from_icon_name ("media-playback-stop-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		properties_button = new Gtk.Button.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
		
		set_titlebar (header);
		add (kb_box);
		kb_box.add (game_screen);
		
		header.pack_start (open_core_button);
		header.pack_start (open_game_button);
		header.pack_start (start_button);
		header.pack_start (pause_button);
		header.pack_start (stop_button);
		header.pack_end (properties_button);
		
		header.set_show_close_button (true);
		
		open_core_button.clicked.connect (on_open_core_button_clicked);
		open_game_button.clicked.connect (on_open_game_button_clicked);
		start_button.clicked.connect (on_start_button_clicked);
		pause_button.clicked.connect (on_pause_button_clicked);
		stop_button.clicked.connect (on_stop_button_clicked);
		properties_button.clicked.connect (on_properties_button_clicked);
		
		audio_dev = new AudioDevice ();
		
		header.show ();
		kb_box.show ();
		game_screen.show ();
		
		open_core_button.show ();
		open_game_button.show ();
		start_button.show ();
		pause_button.show ();
		stop_button.show ();
		properties_button.show ();
	}
	
	void set_titles () {
		header.set_title (engine.info.library_name);
	}
	
	void on_open_core_button_clicked (Gtk.Button button) {
		var dialog = new Gtk.FileChooserDialog ("Open core", this, Gtk.FileChooserAction.OPEN, Stock.CANCEL, ResponseType.CANCEL, Stock.OPEN, ResponseType.ACCEPT);
		
		if (dialog.run () == Gtk.ResponseType.ACCEPT) {
			set_engine (dialog.get_filename ());
		}
		
		dialog.destroy ();
	}
	
	void on_open_game_button_clicked (Gtk.Button button) {
		var dialog = new Gtk.FileChooserDialog ("Open core", this, Gtk.FileChooserAction.OPEN, Stock.CANCEL, ResponseType.CANCEL, Stock.OPEN, ResponseType.ACCEPT);
		
		if (dialog.run () == Gtk.ResponseType.ACCEPT) {
			set_game (dialog.get_filename ());
		}
		
		dialog.destroy ();
	}
	
	void on_start_button_clicked (Gtk.Button button) {
		runner.start ();
	}
	
	void on_pause_button_clicked (Gtk.Button button) {
		runner.stop ();
	}
	
	void on_stop_button_clicked (Gtk.Button button) {
		runner.reset ();
	}
	
	void on_properties_button_clicked (Gtk.Button button) {
		var dialog = new OptionsDialog (engine.options);
		dialog.show_all ();
	}
	
	public void set_engine (string path) {
		stdout.printf ("set_engine (%s)\n", path);
		if (runner != null) {
			runner.stop ();
			runner = null;
		}
		
		engine = new Engine(path);
		
		engine.video_refresh.connect ((pb) => {
			var pbx2 = pb.scale_simple (pb.get_width () * 2, pb.get_height () * 2, Gdk.InterpType.NEAREST);
			game_screen.set_from_pixbuf (pbx2);
		});
		
		engine.audio_refresh.connect ((audio_samples) => {
			audio_dev.play (audio_samples.get_samples ());
			// TODO add a way to set the sample rate of the audio device
		});
		
		engine.set_controller_device (0, kb_box);
		
		runner = new Runner (engine);
		open_game_button.show ();
		set_titles ();
	}
	
	public void set_game (string path) {
		engine.load_game (GameInfo (path));
		
		header.set_subtitle (File.new_for_path (path).get_basename ());
	}
}

