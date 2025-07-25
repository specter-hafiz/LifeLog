import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  const { id, user_id, title, body, mood, created_at } = await req.json();

  const { data: existing, error: selectError } = await supabase
    .from("journal_entries")
    .select("*")
    .eq("user_id", user_id)
    .eq("created_at", created_at)
    .maybeSingle();

  if (selectError) {
    return new Response(JSON.stringify({ error: selectError.message }), {
      status: 400,
    });
  }

  if (existing) {
    return new Response(
      JSON.stringify({ error: "Entry already exists for this day." }),
      { status: 409 }
    );
  }

  const { data, error } = await supabase
    .from("journal_entries")
    .insert({ id, user_id, title, body, mood, created_at })
    .select()
    .single();

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
    });
  }

  return new Response(JSON.stringify(data), { status: 200 });
});
