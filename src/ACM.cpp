//============================================================================
// Name        : ACM.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <curl/curl.h>
#include <iostream>
#include <vector>
#include <queue>
#include <set>
#include <algorithm>
#include <map>
#include <cstdio>
#include <cmath>
#include <fstream>

using namespace std;

struct Match {
	string url;
	string date;
	string home_team;
	string hosts_team;
	int goals_home;
	int goals_hosts;
	int id;
};

struct Goalkeeper {
	int shots;
	int goals;
};

struct Player {
	double goal;
	double assistance;
	double minus_plus;
	double shots;
	double time;
};

struct Players {
	map<string, Player> position_to_representative;
};

vector<Match> matches_;
set<string> teams_;
map<string, Goalkeeper> goalkeepers_;
map<string, Players> players_;

vector<string> process_line(string one_line, string delimiter) {
	vector<string> fields;
	size_t pos = 0;
	std::string token;
	while ((pos = one_line.find(delimiter)) != std::string::npos) {
		token = one_line.substr(0, pos);
		fields.push_back(token);
		one_line.erase(0, pos + delimiter.length());
	}
	fields.push_back(one_line);
	return fields;
}

Match process_match(string one_line) {
	Match m;
	vector<string> fields = process_line(one_line, ",");
	m.id = std::stoi(fields[0]);
	m.url = fields[1];
	m.date = fields[2];
	m.home_team = fields[3];
	m.hosts_team = fields[4];
	m.goals_home = std::stoi(fields[5]);
	m.goals_hosts = std::stoi(fields[6]);
	return m;
}

void process_basic_matches() {
	ifstream input_basic("../input/hockey_matches_limited.csv", ios_base::in);
	string line;
	while (getline(input_basic, line)) {
		matches_.push_back(process_match(line));
	}
}

set<string> different_positions;

Player * getPlayer(string team_name, string position) {
	map<string, Player>& position_to_player =
			players_[team_name].position_to_representative;
	if (position_to_player.find(position) == position_to_player.end()) {
		different_positions.insert(position);
		position_to_player[position] = {0,0,0,0,0};
	}
	return &position_to_player[position];
}

void create_teams() {
	for (const Match& m : matches_) {
		teams_.insert(m.home_team);
		teams_.insert(m.hosts_team);
		goalkeepers_[m.home_team] = {0,0};
		players_[m.home_team] = {map<string, Player>()};
	}
	/*for(const string& s : teams_){
	 cout<<s<<endl;
	 }*/
}

Match getMatchByURL(string url) {
	for (Match m : matches_) {
		if (m.url.compare(url) == 0) {
			return m;
		}
	}
}

void writeGoalkeeperStats(string team_name) {
	cout << ","
			<< (1
					- goalkeepers_[team_name].goals
							/ (double) (
									(goalkeepers_[team_name].shots == 0) ?
											1 : goalkeepers_[team_name].shots));
}

void writePlayersStats(string team_name) {
	vector<string> postitions = { "C", "RW", "LW", "D" };
	for (string pos : postitions) {
		Player& player = *getPlayer(team_name, pos);
		double time = (player.time > 0.3 ? player.time : 1);
		cout << "," << player.assistance / time;
		cout << "," << player.goal / time;
		cout << "," << player.minus_plus / time;
		cout << "," << player.shots / time;
	}
}

void writeMLRow(Match match) {
	cout << ((match.goals_home > match.goals_hosts) ? 1 : 0);
	writeGoalkeeperStats(match.home_team);
	writePlayersStats(match.home_team);
	writeGoalkeeperStats(match.hosts_team);
	writePlayersStats(match.hosts_team);
	cout << endl;
}

void process_goalkeeper(ifstream& stream, bool home) {
	string line;
	while (getline(stream, line) && !line.empty()) {
		vector<string> fields = process_line(line, " ");

		vector<string> name = process_line(line, "\"");
		vector<string> names = process_line(name[1], " ");
		int offset = names.size() - 1;

		Match match = getMatchByURL(fields[0]);
		// should be in the better place
		if (home) {
			writeMLRow(match);
		}
		string team_name = (home) ? match.home_team : match.hosts_team;
		goalkeepers_[team_name].goals += std::stoi(fields[4 + offset]);
		goalkeepers_[team_name].shots += std::stoi(fields[5 + offset]);
		//cout<<fields[5 + offset]<<" "<<endl;
	}
}

double process_time_to_min(string time) {
	vector<string> fields = process_line(time, ":");
	double T = std::stoi(fields[0]);
	T += std::stoi(fields[1]) / 60.0;
	return T;
}

void mve(Player& to, Player& from, double scale) {
	to.assistance += from.assistance / scale;
	to.goal += from.goal / scale;
	to.minus_plus += from.minus_plus / scale;
	to.shots += from.shots / scale;
	to.time += from.time / scale;
}

void zero(Player& z) {
	z.assistance = 0;
	z.goal = 0;
	z.minus_plus = 0;
	z.shots = 0;
	z.time = 0;
}

void normalizePositions(string team_name) {
	map<string, Player>& position_to_player =
			players_[team_name].position_to_representative;
	for (map<string, Player>::iterator it = position_to_player.begin();
			it != position_to_player.end(); ++it) {
		Player& player = it->second;
		if (it->first.compare("CRW") == 0) {
			mve(*getPlayer(team_name, "C"), player, 2);
			mve(*getPlayer(team_name, "RW"), player, 2);
			zero(player);
		}
		if (it->first.compare("CLW") == 0) {
			mve(*getPlayer(team_name, "C"), player, 2);
			mve(*getPlayer(team_name, "LW"), player, 2);
			zero(player);
		}
		if (it->first.compare("F") == 0) {
			mve(*getPlayer(team_name, "RW"), player, 2);
			mve(*getPlayer(team_name, "LW"), player, 2);
			zero(player);
		}
		if (it->first.compare("CW") == 0) {
			mve(*getPlayer(team_name, "C"), player, 3);
			mve(*getPlayer(team_name, "LW"), player, 3);
			mve(*getPlayer(team_name, "RW"), player, 3);
			zero(player);
		}
		if (it->first.compare("G") == 0) {
			zero(player);
		}
	}
}

void process_players(ifstream& stream, bool home) {
	string line;
	string team_name;
	while (getline(stream, line) && !line.empty()) {
		vector<string> fields = process_line(line, " ");

		vector<string> name = process_line(line, "\"");
		vector<string> names = process_line(name[1], " ");
		int offset = names.size() - 1;

		Match match = getMatchByURL(fields[0]);
		team_name = (home) ? match.home_team : match.hosts_team;
		Player& player = *getPlayer(team_name, fields[3 + offset]);
		player.goal += std::stoi(fields[4 + offset]);
		player.assistance += std::stoi(fields[5 + offset]);
		player.minus_plus += std::stoi(fields[6 + offset]);
		player.shots += std::stoi(fields[7 + offset]);
		player.time += process_time_to_min(fields[8 + offset]);
		//cout<<fields[3+offset]<<" "<<player.time<<endl;
	}
	normalizePositions(team_name);
}

void process_advanced_matches() {
	ifstream input_advanced("../input/matches_output_update.csv", ios_base::in);

	int a = 1000;
	while (a--) {
		process_goalkeeper(input_advanced, true);
		process_players(input_advanced, true);
		process_goalkeeper(input_advanced, false);
		process_players(input_advanced, false);
	}
}

int main() {
	CURL *curl;
	CURLcode res;
	curl_global_init(CURL_GLOBAL_ALL);

	curl = curl_easy_init();
	if (curl) {
		/* First set the URL that is about to receive our POST. This URL can
		 just as well be a https:// URL if that is what should receive the
		 data. */
		curl_easy_setopt(curl, CURLOPT_URL,
				"https://www.googleapis.com/prediction/v1.6/projects/hackcambridge-3372/trainedmodels/hockey1/predict?key={YOUR_API_KEY}");
		/* Now specify the POST data */
		curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "name=daniel&project=curl");

		/* Perform the request, res will get the return code */
		res = curl_easy_perform(curl);
		/* Check for errors */
		if (res != CURLE_OK)
			fprintf(stderr, "curl_easy_perform() failed: %s\n",
					curl_easy_strerror(res));

		/* always cleanup */
		curl_easy_cleanup(curl);
	}
	curl_global_cleanup();
	return 0;

	process_basic_matches();
	create_teams();
	process_advanced_matches();
	/*for (string s : different_positions) {
	 cout << s << endl;
	 }*/
}
