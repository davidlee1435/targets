part of targets_cli;

/**
 * tester.dart is copied into the targets folder every time tests are run
 * The contents are kept in a string here so that pub doesn't precompile
 * it when installing targets with `pub global activate targets`
 */

final String tester_dart = 
r"""// targets uses this file to test your code
// Changing it will not improve your grade
// It will only make it harder for you to run tests

import 'dart:io';
import 'tests.dart' as Tests;
import 'helpers.dart';

main(List<String> args){
    if(args.length==0)runTests();
    else if(args[0]=="submit"){
        print(Tests.owner+":"+Tests.id);
        for(String file in Tests.files){
            print(file);
        }
    }
}

void runTests(){
    try{
        print(Tests.name, BLUE);
        print("");
    }catch(e){

    }
    List<Target> targets = Tests.getTargets();
    num score = 0;
    num maxPoints = 0;
    bool allPassed = true;
    for(Target t in targets){
        if(t is ScoredTarget){
            if(!t.uncounted) maxPoints += t.points;
            var s = 0;
            try{
                s = t.test();
                if(s==null)s=0;
            }catch(e, st){
                print("Test ${t.name} failed with error: $e $st", RED);
            }
            if(s is bool){
                if(s){
                    s = t.points;
                    score += t.points;
                }else s = 0;
            }else if(s != null) score += s;
            String extra = "";
            if(t.error!=null){
                extra = " - ${t.error}";
            }
            print("${t.name}: $s/${t.points}$extra");
        }else if(t is TestTarget){
            bool result = false;
            try{
                result = t.test();
                if(result==null)result=false;
            }catch(e, st){
                print("Test ${t.name} failed with error: $e $st", RED);
            }
            String extra = "";
            if(t.error!=null){
                extra = " - ${t.error}";
            }
            if (t.points <= 0) {
                if(result){
                    print("${t.name}: Passed$extra");
                }else{
                    print("${t.name}: Failed$extra");
                    if(!t.uncounted) allPassed = false;
                }
            } else {
                if(!t.uncounted) maxPoints += t.points;
                if(result){
                    score += t.points;
                    print("${t.name}: Passed (${t.points} points)$extra");
                } else {
                    print("${t.name}: Failed (${t.points} points)$extra");
                }
            }
        }
    }
    if(maxPoints>0){
        if(score>=maxPoints) print("Total Score: $score/$maxPoints", GREEN);
        else print("Total Score: $score/$maxPoints", RED);
        if(!allPassed) print("Some Additional Tests Failed", RED);
    }else{
        if(allPassed) print("All Required Tests Passed!", GREEN);
        else print("Some Required Tests Failed", RED);
    }
}

const String PLAIN = "plain";
const String GREEN = "green";
const String RED = "red";
const String BLUE = "blue";

Function print = (String str, [String type=PLAIN]){
    if(type==PLAIN||Platform.isWindows){
        stdout.writeln(str);
    }else if(type==RED){
        stdout.writeln("\u001b[0;31m"+str+"\u001b[0;0m");
    }else if(type==GREEN){
        stdout.writeln("\u001b[0;32m"+str+"\u001b[0;0m");
    }else if(type==BLUE){
        stdout.writeln("\u001b[0;36m"+str+"\u001b[0;0m");
    }
};
""";